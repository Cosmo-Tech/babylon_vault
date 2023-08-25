#!/bin/bash

ip_address="$(ip addr show eth0 | perl -n -e'/ inet (\d+(\.\d+)+)/ && print $1')"


# install vault.
sudo apt install -y wget gpg
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update -y && sudo apt install vault -y

cat >/etc/vault.d/vault.hcl <<EOF
ui = true
disable_mlock = true

api_addr = "http://$ip_address:8200"
cluster_addr = "http://$ip_address:8201"

storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address         = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable     = 1
  telemetry {
    unauthenticated_metrics_access = true
  }
}

# enable the telemetry endpoint.
# access it at http://<VAULT-IP-ADDRESS>:8200/v1/sys/metrics?format=prometheus
# see https://www.vaultproject.io/docs/configuration/telemetry
# see https://www.vaultproject.io/docs/configuration/listener/tcp#telemetry-parameters
telemetry {
   disable_hostname = true
   prometheus_retention_time = "24h"
}

# enable auto-unseal using the azure key vault.
seal "azurekeyvault" {
  client_id      = "${client_id}"
  client_secret  = "${client_secret}"
  tenant_id      = "${tenant_id}"
  vault_name     = "${vault_name}"
  key_name       = "${key_name}"
}
EOF

systemctl enable vault
systemctl restart vault

cat >/etc/profile.d/vault.sh <<EOF
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true
EOF

# nginx
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
sudo apt update -y
sudo apt install nginx -y
chmod 777 -R /etc/nginx

# let's encrypt
sudo apt install -y certbot python-certbot-nginx
chmod 777 -R /etc/letsencrypt

cat >/home/azureuser/vault.conf <<EOF
server {
    listen  443 ssl;
    listen [::]:443 ssl;
    server_name localhost;

    error_page  500 502 503 504  /50x.html;
    location = /50x.html {
        root  /usr/share/nginx/html;
    }

    ssl_certificate /etc/letsencrypt/live/${domain_label}.${location}.cloudapp.azure.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${domain_label}.${location}.cloudapp.azure.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.1 TLSv1;
    
    location / {
      proxy_pass http://localhost:8200;
      proxy_set_header Host \$http_host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

cat >/home/azureuser/nginx_init.sh <<EOF
#!/bin/bash
sudo systemctl stop nginx
sudo certbot certonly --nginx -d "${domain_label}.${location}.cloudapp.azure.com" -m ${email} --agree-tos --no-eff-email
sudo rm /etc/nginx/conf.d/default.conf
sudo mv /home/azureuser/vault.conf /etc/nginx/conf.d/default.conf
sudo systemctl restart nginx
EOF
chmod 777 /home/azureuser/nginx_init.sh
chmod +x /home/azureuser/nginx_init.sh

sudo systemctl start nginx

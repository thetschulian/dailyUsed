sudo apt-get update -y
sudo apt-get install ca-certificates curl nfs-common
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
 
 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 
sudo apt-get update -y
 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker vault
 
mkdir Vault
mkdir Vault/certs

sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048   -keyout Vault/certs/vaultwarden.key   -out Vault/certs/vaultwarden.crt   -subj "/CN=vaultwarden.local"

touch Vault/docker-compose.yaml
	 
sudo  chown -R un26-vault /home/vault
sudo reboot

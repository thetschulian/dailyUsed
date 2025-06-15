	# 1. Prepare Environment

##############################################
########### FIRST  COPY BLOCK START ###########

#!/bin/bash

	# Collect Informations

USERNAME="changeme"                                #needs to match the username of your new VM
BASENAME="MY-Vault"								                 #Name of the Main-Vaultwarden Folder in your Home-Directory

PG_CONTAINER="vaultwarden-db"							         #needs to match your data in docker compose
PG_USERNAME="vaultuser"								             #needs to match your data in docker compose
PG_DBNAME="vaultwarden"								             #needs to match your data in docker compose // dont change! if you change edit drop and create database statement below manually


BASE_DIR="/home/$USERNAME/$BASENAME"	
BACKUP_MNT="192.168.0.0:/mnt/usb-backupdisk/BACKUP-DISK/VaultWarden"    #only needed if you have your backup on a foreign nfs share otherwise just edit "BACKUP_SOURCE_DIR"
BACKUP_SOURCE_DIR="/mnt/ESX-USB-BACKUP"                                 #change to the directory where your BACKUP_FILE_NAME and BACKUP_SQL_NAM 
BACKUP_FILE_NAME="vaultwarden_full_2025-06-14_12-57"   				          #Points to a .tar.gz
BACKUP_SQL_NAME="postgres_2025-06-14_12-57"  					                  #Points to .sql.gz   OR  .sql  



mkdir $BASE_DIR
mkdir $BASE_DIR/certs
sudo mkdir $BACKUP_SOURCE_DIR

sudo apt-get update -y
sudo apt-get install nfs-common -y
echo "Make sure you can reach the NFS share - check /etc/exports on your NFS Server)"
sudo mount -t nfs $BACKUP_MNT $BACKUP_SOURCE_DIR
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
 
 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 
sudo apt-get update -y
 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker $USERNAME
 
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048   -keyout $BASE_DIR/certs/vaultwarden.key   -out $BASE_DIR/certs/vaultwarden.crt   -subj "/CN=vaultwarden.local"

touch $BASE_DIR/docker-compose.yaml
	 
sudo chown -R $USERNAME /home/$USERNAME


	# 2. Restore Backup
 	
echo "Extract Backup Source to gain vw-data and  docker-compose"
tar -xzvf $BACKUP_SOURCE_DIR/$BACKUP_FILE_NAME.tar.gz -C $BASE_DIR --strip-components=1
echo "Extract the SQL Dump"
gzip -d -c $BACKUP_SOURCE_DIR/$BACKUP_SQL_NAME.sql.gz > $BASE_DIR/$BACKUP_SQL_NAME.sql

cd $BASE_DIR
echo "Creating the Docker Containers for Vaultwarden and vaultwarden postgres with docker compose up"
sudo docker compose up -d

echo "Switch Context to the psql CLI - sleep 5 seconds now "
sleep 5
sudo docker exec -it $PG_CONTAINER psql -U $PG_USERNAME -d postgres
echo "Connecting to Database 'postgres' to be able to drop and create the $PG_DBNAME database"
echo "var PG_DBNAME should match the dropped and created Database below"

echo "Now  drop and Create Databases"
echo "Info: Databasenames may be different"

echo "You can now copy the next block"
########### FIRST  COPY BLOCK END ###########
#############################################

	# 3. Clean the default Databse - login to postgres DB as a helper DB

################################################
########### SECOND  COPY BLOCK START ###########



				REVOKE CONNECT ON DATABASE vaultwarden FROM public;
				SELECT pg_terminate_backend(pg_stat_activity.pid)
				FROM pg_stat_activity
				WHERE pg_stat_activity.datname = 'vaultwarden';
				
				DROP DATABASE vaultwarden;
							
				CREATE DATABASE vaultwarden;
				
				\q
    

########### SECOND  COPY  BLOCK END  ###########	
###############################################

	# 4. Import the Dump

########### THIRD  COPY  BLOCK START  ###########	
#################################################

echo "Import the SQL Dump now:"
cat $BASE_DIR/$BACKUP_SQL_NAME.sql | sudo docker exec -i $PG_CONTAINER psql -U $PG_USERNAME -d $PG_DBNAME

	# 5. Test your Restoring
echo "Open  https://deineip"
sleep 5
echo "Open  https://deineip"
sleep 5
echo "Open  https://deineip"

########### THIRD  COPY  BLOCK END  #############	
#################################################

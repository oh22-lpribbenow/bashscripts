#!/bin/bash
useradd -m sftpuser
echo "Type in password for sftpuser"
passwd sftpuser
service sshd restart
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update
apt install blobfuse
mkdir /mnt/blobfusetmp -p
chown sftpuser /mnt/blobfusetmp
echo "Type in Storage Account Name"
read accountName
echo "Type in Storage Account Key"
read accountKey
echo "Type in Storage Container Name"
read containerName
echo accountName $accountName > /home/sftpuser/fuse_connection.cfg
echo accountKey $accountKey >> /home/sftpuser/fuse_connection.cfg
echo containerName $containerName >> /home/sftpuser/fuse_connection.cfg
mkdir /home/sftpuser/azstoragecontainer -p
chown -R sftpuser /home/sftpuser
sudo -u sftpuser blobfuse /home/sftpuser/azstoragecontainer --tmp-path=/mnt/blobfusetmp  --config-file=/home/sftpuser/fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120
echo "@reboot sftpuser blobfuse /home/sftpuser/azstoragecontainer --tmp-path=/mnt/blobfusetmp  --config-file=/home/sftpuser/fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120" > /etc/cron.d/mountblob

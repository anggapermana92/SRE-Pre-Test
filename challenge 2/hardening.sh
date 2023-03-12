#!/bin/bash


# Update the system
apt-get update && apt-get upgrade -y

# Install and configure a firewall
apt-get install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw enable
echo ""

#configure SSH

sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication prohibit-password/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
systemctl restart sshd
echo ""


# Generate SSH keys
ssh-keygen -b 4096
echo ""

# Copy the public key to the server
cp /root/.ssh/id_rsa.pub /home/test/.ssh/authorized_keys
echo ""

# Disable unnecessary services
systemctl stop apache2
systemctl disable apache2
echo ""


# Remove unused packages
apt-get autoremove -y

# Configure secure DNS resolver
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
echo ""


# Configure web server to use HTTPS
apt-get install certbot -y
certbot --nginx -d example.com --register-unsafely-without-email
systemctl restart nginx

# Configure strong password policy
apt-get install libpam-cracklib -y
sed -i 's/password    requisite     pam_cracklib.so retry=3 minlen=8 difok=3/password    requisite     pam_cracklib.so retry=3 minlen=15 difok=4/g' /etc/pam.d/common-password
echo ""

# Enable password complexity
sed -i 's/password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=/password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type= ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/g' /etc/pam.d/common-password

echo -e "Harden Done"


echo '>>ADDING GOOGLE NAMESERVER'
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

# apt -y update && apt -y upgrade
apt update
#https://github.com/chef/bento/issues/661#issuecomment-248136601
apt DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

apt install git screen memcached tcpdump tshark build-essentials

echo '>>APACHE2.4'
apt -y install apache2
cd /etc/apache2/mods-available
a2enmod rewrite
a2enmod ssl
a2enmod header
a2enmod proxy

echo '>>PHP7.2'
apt -y install apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt -y update
apt -y install php7.2 libapache2-mod-php7.2 php7.2-common php7.2-cli php7.2-opcache php7.2-json php7.2-readline php7.2-gd php7.2-mbstring php7.2-xml php7.2-mysql php7.2-soap php7.2-zip php7.2-curl php7.2-apc php-memcached

echo ">>SUPERVISOR"
apt -y install supervisor

echo ">>REDIS"
apt -y install redis-server

echo '>>SSH'
sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
sed -i 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/' /etc/ssh/sshd_config
sed -i 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/' /etc/ssh/sshd_config
sed -i 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/' /etc/ssh/sshd_config
sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

echo '>>UFW'
apt -y install ufw
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3306
ufw allow 9000
ufw allow 6379
ufw allow 11211

echo '>>ADD TO START UP'
systemctl enable apache2
systemctl enable supervisor
systemctl enable redis
systemctl enable ufw

echo '>>use PH localtime'
rm /etc/localtime && \
ln -s /usr/share/zoneinfo/Asia/Manila /etc/localtime

# COMPOSER
# Install Composer manually since it always updates
# Go to https://getcomposer.org/download/
# Execute the command line installation
# After getting the composer.phar, move it to /usr/local/bin/composer - mv composer.phar /usr/local/bin/composer

# echo '>>MYSQL'
# wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
# dpkg -i mysql-apt-config_0.8.10-1_all.deb
# Select Version 5.7
# dpkg-reconfigure mysql-apt-config
# apt -y update && apt -y upgrade
# apt -y install mysql-server
# sed -i 's/bind-address/# bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
# echo sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf
# systemctl enable mysql
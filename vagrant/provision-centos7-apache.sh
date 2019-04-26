echo '>>ADDING GOOGLE NAMESERVER'
echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

yum -y update

yum -y install wget git screen

echo '>>EPEL'
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

echo '>>APACHE'
yum -y install httpd

echo '>>REMI-PHP'
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum update

echo '>>PHP7'
yum -y install php72-php php72-php-mcrypt php72-php-gd php72-php-mbstring php72-php-xml php72-php-mysql php72-php-soap php72-php-apc php72-php-opcache php72-php-memcache php72-php-memcached --enablerepo=remi-php72

echo '>>CREATE PHP EXECUTABLE'
ln -s /usr/bin/php72 /usr/local/bin/php

echo '>>MYSQL'
yum -y install http://repo.mysql.com/mysql-community-release-el7-7.noarch.rpm
yum update
yum -y install mysql-server

echo '>>SSH SETTINGS'
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#Protocol 2/Protocol 2/' /etc/ssh/sshd_config

echo '>>IPTABLES'
sudo systemctl stop firewalld
sudo systemctl disable firewalld
yum -y install iptables-services

echo '>>START SERVICES'
sudo systemctl start httpd
sudo systemctl start mysqld
sudo systemctl start iptables

echo '>>STARTUP SERVICES'
sudo systemctl enable sshd
sudo systemctl enable httpd
sudo systemctl enable mysqld
sudo systemctl enable iptables

echo '>>COMPOSER'
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php -r "if (hash_file('SHA384', 'composer-setup.php') === '7228c001f88bee97506740ef0888240bd8a760b046ee16db8f4095c0d8d525f2367663f22a46b48d072c816e7fe19959') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
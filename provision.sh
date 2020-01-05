#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='password1234'

echo ">> Starting Install Script"

# Update
sudo yum -y update
#sudo rpm -Uvh http://repo.webtatic.com/yum/el6/latest.rpm;
sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm 

echo "MySQL"
sudo rpm -Uvh http://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm
sudo yum -y install mysql mysql-server
sudo echo "query_cache_type=1" >> /etc/my.cnf
sudo echo "query_cache_size = 1024M" >> /etc/my.cnf
sudo echo "query_cache_limit = 128M" >> /etc/my.cnf
sudo echo "tmp_table_size = 256M" >> /etc/my.cnf
sudo echo "max_heap_table_size = 256M" >> /etc/my.cnf
sudo echo "ft_min_word_len = 2" >> /etc/my.cnf
sudo echo "innodb_ft_min_token_size = 2" >> /etc/my.cnf


echo ">> Installing Web Server Items.."

sudo yum -y --enablerepo=remi,remi-php56 install httpd php php-common
sudo yum -y --enablerepo=remi,remi-php56 install php-pecl-apcu php-pecl-redis php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-sqlite libmemcached-last php-pecl-memcache php-pecl-memcached 
sudo yum -y --enablerepo=remi,remi-php56 install php-gd php-mbstring php-mcrypt php-xml php-mysqli php-soap php-pecl-apc
sudo yum -y install mod_perl

## Configure APC Module
#sudo vi /etc/php.d/40-apcu.ini
#apc.shm_size=1024M

echo ">> Configuring web services ... restarting httpd "

sudo service httpd restart
sudo service mysqld restart

## 5 CentOS / RHEL 6.7/5.11 ##
sudo chkconfig --levels 235 httpd on
sudo chkconfig --levels 235 mysqld on

## OPTIONAL DEV SETUPS ##

# PHP Config
# targeted sed script ..
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php.ini

# A bit on the "dangerous" side but for the dev boxes should be fine
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

echo ">> Installing Redis.. "
# download and install redis
sudo yum install redis -y

sudo chkconfig --add redis
sudo chkconfig --level 345 redis on

# ... Add index.html ... so no one can see directory
sudo touch /var/www/html/index.html

# Composer
echo ">> Installing Composer.."

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

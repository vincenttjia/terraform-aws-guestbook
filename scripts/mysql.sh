#!/bin/bash
sudo apt update

#Install DB
sudo apt install -y mysql-server

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MyDBPassword}'"
sudo mysql -e "CREATE USER '${MyDBUsername}'@'%' IDENTIFIED BY '${MyDBPassword}'"
sudo mysql -e "CREATE DATABASE ${DBName}"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DBName}.* TO '${MyDBUsername}'@'%'"
sudo mysql -e "FLUSH PRIVILEGES"

sudo sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql
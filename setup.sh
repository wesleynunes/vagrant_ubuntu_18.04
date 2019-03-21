# Instalando e configurando servidor apache php ubuntu 18.04

echo "--- Instalando pacotes para desenvolvimento [PHP]"

# Criar variaves para senha mysql, nome do projeto, git
echo "--- Definir senha mysql, nome do projeto, nome email do git---"
PASSWORD='123'
PROJECTFOLDER='projeto'
GITNAME="Wes"
GITEMAIL="wesleysilva.ti@gmail.com"

echo "--- criar pasta do projeto ---"
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

echo "<?php phpinfo(); ?>" > /var/www/html/${PROJECTFOLDER}/index.php

echo "--- update / upgrade ---"
sudo apt-get update
sudo apt-get -y upgrade

echo "--- instalar apache2 ---"
sudo apt-get -y install apache2

echo "--- instalar php, libapache2-mod-php ---"
sudo apt-get -y install php libapache2-mod-php 

echo "--- instalar mysql e fornercer senha para o instalador, instalando php-mysql-- "
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get -y install php-mysql

echo "--- instalar phpmyadmin e fornecer senha para o instalador"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

echo "--- Configurando arquivo host ---"
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

echo "--- habilitar mod-rewrite do apache ---"
sudo a2enmod rewrite

echo "--- reiniciar mysql ---"
sudo service mysql restart

echo "--- reiniciar apache ---"
sudo service apache2 restart

echo "--- instalando e configurando git ---"
sudo apt-get -y install git 
git config --global user.name ${GITNAME} 
git config --global user.email ${GITEMAIL}

echo "--- reiniciar apache ---"
sudo service apache2 restart

echo "[OK] --- Ambiente de desenvolvimento concluido ---"
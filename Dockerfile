# Choose OS
FROM	debian:buster

# Copy files to current directory
COPY	srcs/. /root/

# Installing updates, wget and nginx
RUN		apt-get update
RUN		apt-get upgrade -y # The -y says yes to everything asked by the upgrade command
RUN		apt-get -y install wget
RUN		apt-get -y install apt-utils
RUN		apt-get -y install nginx

# Install Mysql
RUN		apt-get -y install mariadb-server

# Install SSL
RUN		apt-get -y install libnss3-tools

# Install PHP
RUN		apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

# Put the config file for nginx into the sites-available folder
RUN		mv /root/nginx.conf /etc/nginx/sites-available/localhost										#Dit gaat vooralsnog mis, gaat wel goed als ik deze twee lines uitcomment.
RUN		ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
# Does the default need to be removed?

# Start services
#RUN		service nginx start \
#		service mysql start \
#		service php7.3-fpm start

# Configure wordpress database
#RUN		echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password \
#		echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password \
#		echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password \
#		echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

# Configure PHP
WORKDIR	/var/www/html/
RUN		wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN		tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN		mv phpMyAdmin-5.0.1-english phpmyadmin
RUN		mv /root/config.inc.php /etc/www/html/phpmyadmin/

# Install wordpress
RUN		wget https://wordpress.org/latest.tar.gz
RUN		tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN		mv /root/wp-config.php /var/www/html/

RUN		openssl req -x509 -nodes -days 365 -subj "/C=KR/ST=Korea/L=Seoul/O=innoaca/OU=42seoul/CN=forhjy" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;


# docker build -t mycontainer . # Create container namer mycontainer, the dot is to tell Docker it should look for the Dockerile in the current directory.
# docker run -it --rm -p 80:80 nginx   # Use the -p flag to explicitly map a single port or range of ports
# CMD echo 'test'
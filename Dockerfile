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
RUN		mv /root/nginx.conf /etc/nginx/sites-available/localhost
RUN		ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
# Does the default need to be removed?


RUN		openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/C=US/CN=AlexanderRoot-CA"
# Configure wordpress database
Run		bash /root/sqlscript.sh

# Configure PHP
WORKDIR	/var/www/html/
RUN		wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN		tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN		mv phpMyAdmin-5.0.1-english phpmyadmin
RUN		mv /root/config.inc.php ./phpmyadmin/

# # Install wordpress
RUN		wget https://wordpress.org/latest.tar.gz
RUN		tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN		mv /root/wp-config.php /var/www/html/

# Change authorization
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*
CMD bash /root/init.sh && && nginx -g 'daemon off;'

EXPOSE 80

# Start services
#RUN		service nginx start \
#		service mysql start \
#		service php7.3-fpm start

# docker build -t nginx . # Create container namer mycontainer, the dot is to tell Docker it should look for the Dockerile in the current directory.
# docker run -it --rm -p 80:80 nginx   # Use the -p flag to explicitly map a single port or range of ports
# CMD echo 'test'
# Choose OS
FROM	debian:buster

# Copy files to current directory
COPY	srcs/. /root/

# Installing updates, wget and nginx
RUN		apt-get update
RUN		apt-get upgrade -y
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

# Configure SSL certificate
RUN 		wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
RUN			chmod 777 mkcert-v1.4.3-linux-amd64
RUN			./mkcert-v1.4.3-linux-amd64 localhost
RUN			rm -rf ./mkcert-v1.4.3-linux-amd64
RUN			mv ./localhost.pem ./etc/nginx
RUN			mv ./localhost-key.pem ./etc/nginx
# RUN		openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/C=US/CN=AlexanderRoot-CA"
# Configure wordpress database
RUN		bash /root/sqlscript.sh

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
RUN		chown -R www-data:www-data *
RUN		chmod -R 755 /var/www/*
CMD		service mysql restart && service php7.3-fpm start && nginx -g 'daemon off;'
# CMD bash /root/init.sh

EXPOSE 80

# Start services
#RUN		service nginx start \
#		service mysql start \
#		service php7.3-fpm start

# docker build -t nginx . # Create container namer mycontainer, the dot is to tell Docker it should look for the Dockerile in the current directory.
# docker run -it --rm -p 80:80 nginx   # Use the -p flag to explicitly map a single port or range of ports
# CMD echo 'test'
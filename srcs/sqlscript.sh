service mysql start
echo "CREATE DATABASE wordpress" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'root'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
echo "update mysql.user set plugin = '' where user='root';" | mysql -u root
#  DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; line comes from behind wordpress at line 2
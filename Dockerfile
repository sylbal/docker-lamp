FROM debian:jessie

RUN apt-get update

RUN apt-get install -y ca-certificates curl libpcre3 librecode0 libsqlite3-0 libxml2 --no-install-recommends

# MySQL
ENV DB_ROOT_PWD root
#ENV DB_USER user
#ENV DB_USER_PWD password

RUN echo "mysql-server mysql-server/root_password password $DB_ROOT_PWD" | debconf-set-selections;\
    echo "mysql-server mysql-server/root_password_again password $DB_ROOT_PWD" | debconf-set-selections;

RUN apt-get install -y mysql-server --no-install-recommends

# Create an user
#RUN /usr/sbin/mysqld & \
#    sleep 5s &&\
#    echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '$DB_ROOT_PWD'; FLUSH PRIVILEGES" | mysql --user=root --password=$DB_ROOT_PWD &&\
#    echo "GRANT ALL ON *.* TO $DB_USER@'%' IDENTIFIED BY '$DB_USER_PWD' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql --user=root --password=$DB_ROOT_PWD

# Apache
RUN apt-get install -y apache2 --no-install-recommends

RUN rm -rf /var/www/html && mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html && chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html

RUN a2enmod rewrite

# PHP 5
RUN apt-get install -y php5 php5-mysql php5-mcrypt php5-gd php5-curl

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 80

# start servers
ADD startServers.sh /root/startServers.sh
RUN chmod 755 /root/startServers.sh

CMD ["/root/startServers.sh"]

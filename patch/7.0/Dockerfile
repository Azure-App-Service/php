FROM appsvc/php:7.0.33-apache_1903071319

# logs should go to stdout / stderr
RUN	rm -f /var/log/apache2; \
    mkdir /var/log/apache2; \
    ln -sfT /dev/stderr "/var/log/apache2/error.log"; \
    ln -sfT /dev/stdout "/var/log/apache2/access.log"; \
    ln -sfT /dev/stdout "/var/log/apache2/other_vhosts_access.log"; \
    chown -R "www-data:www-data" /var/log/apache2/*.log;\
    rm -f /etc/apache2/conf-enabled/other-vhosts-access-log.conf

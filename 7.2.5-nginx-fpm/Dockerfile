FROM php:7.2.5-fpm-alpine3.7
LABEL maintainer="Azure App Services Container Images <appsvc-images@microsoft.com>"

COPY init_container.sh /bin/init_container.sh
COPY hostingstart.html /home/site/wwwroot/hostingstart.html

RUN chmod 755 /bin/init_container.sh && \
    # set log directories
   chmod 777 /var/log && \
    chmod 777 /var/run && \
    chmod 777 /var/lock && \
    rm -rf /var/www/html && \
    rm -rf /var/log/nginx && \
    mkdir -p /home/LogFiles && \
    ln -s /home/site/wwwroot /var/www/html && \
    ln -s /home/LogFiles /var/log/nginx && \
    # Install Nginx
    apk update && \
    apk add nginx && \
    # user www-data should already exist
    chown -R www-data:www-data /var/lib/nginx && \
    chown -R www-data:www-data /var/www/html

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

# install libraries and tools we need
# best guesses
RUN apk update && \
    apk add --no-cache openrc \
        libpng-dev \
        libjpeg-turbo-dev \
        postgresql-dev \
        libmcrypt-dev \
        libmcrypt \
        openldap-dev \
        ldb-dev \
        icu-dev \
        gmp-dev \
        imagemagick-dev \
        imap-dev \
        tidyhtml-dev \
        krb5-dev \
        gettext-dev \
        autoconf \
        make \
        g++ \
        libxslt-dev \
        unixodbc-dev \
        openssh-server \
        openssh \
        vim \
        curl \
        wget \
        tcptraceroute && \
    echo "root:Docker!" | chpasswd && \
    echo "cd /home" >> /etc/bash.bashrc && \
    pecl install imagick-beta && \
    pecl install mcrypt-1.0.1 && \
    # install php extensions
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-install gd \
        mysqli \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        ldap \
        intl \
        gmp \
        zip \
        bcmath \
        mbstring \
        pcntl \
        calendar \
        exif \
        gettext \
        imap \
        tidy \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \   
        pdo_odbc \
        wddx \
        xmlrpc \
        xsl && \
    docker-php-ext-enable imagick && \
    docker-php-ext-enable mcrypt

# install odbc php ext
RUN apk update && \
    apk add unixodbc-dev

RUN set -x && \
    docker-php-source extract && \
    cd /usr/src/php/ext/odbc && \
    phpize && \
    sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure && \
    ./configure --with-unixODBC=shared,/usr && \
    docker-php-ext-install odbc

# php settings
RUN { \
                echo 'opcache.memory_consumption=128'; \
                echo 'opcache.interned_strings_buffer=8'; \
                echo 'opcache.max_accelerated_files=4000'; \
                echo 'opcache.revalidate_freq=60'; \
                echo 'opcache.fast_shutdown=1'; \
                echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
                echo 'error_log=/var/log/nginx/php-error.log'; \
                echo 'display_errors=Off'; \
                echo 'log_errors=On'; \
                echo 'display_startup_errors=Off'; \
                echo 'date.timezone=UTC'; \
    } > /usr/local/etc/php/conf.d/php.ini

# openrc settings
# https://github.com/dockage/alpine-openrc/blob/master/Dockerfile
RUN sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab && \
    sed -i \
        # Change subsystem type to "docker"
        -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
        # Allow all variables through
        -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
        # Start crashed services
        -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
        -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
        # Define extra dependencies for services
        -e 's/#rc_provide=".*"/rc_provide="loopback net"/g' \
        /etc/rc.conf && \
# Remove unnecessary services
    rm -f /etc/init.d/hwdrivers \
            /etc/init.d/hwclock \
            /etc/init.d/hwdrivers \
            /etc/init.d/modules \
            /etc/init.d/modules-load \
            /etc/init.d/modloop && \
    # Can't do cgroups
    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
    sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh

# Expose ports
# http
EXPOSE 8080
# ssh
EXPOSE 2222

COPY www.conf /usr/local/etc/php-fpm.d/www.conf
# replace zz-docker
COPY zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY sshd_config /etc/ssh/sshd_config
COPY php-fpm.init /etc/init.d/php-fpm
RUN chmod 777 /etc/init.d/php-fpm

ENV PHP_VERSION 7.2.5
ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

WORKDIR /home/site/wwwroot

ENTRYPOINT ["/bin/init_container.sh"]

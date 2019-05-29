FROM mcr.microsoft.com/oryx/php-7.3:20190518.2
LABEL maintainer="Azure App Services Container Images <appsvc-images@microsoft.com>"

ENV PHP_VERSION 7.3

COPY init_container.sh /bin/
COPY hostingstart.html /home/site/wwwroot/hostingstart.html

RUN chmod 755 /bin/init_container.sh \
    && mkdir -p /home/LogFiles/ \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home/site/wwwroot" >> /etc/bash.bashrc \
    && ln -s /home/site/wwwroot /var/www/html \
    && mkdir -p /opt/startup

# configure startup
COPY sshd_config /etc/ssh/
COPY ssh_setup.sh /tmp
RUN mkdir -p /opt/startup \
   && chmod -R +x /opt/startup \
   && chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) \
   && rm -rf /tmp/*

ENV PORT 8080
ENV SSH_PORT 2222
EXPOSE 2222 8080
COPY sshd_config /etc/ssh/

ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

RUN { \
    echo 'DocumentRoot /home/site/wwwroot'; \
    echo 'DirectoryIndex default.htm default.html index.htm index.html index.php hostingstart.html'; \
    echo 'ServerName localhost'; \
} >> /etc/apache2/apache2.conf

WORKDIR /home/site/wwwroot

ENTRYPOINT ["/bin/init_container.sh"]


ARG php_version

# CraftCMS dependencies
FROM ghcr.io/craftcms/image:${php_version}

USER root

RUN apt-get update --fix-missing
RUN apt-get install -y curl
RUN apt-get install -y nano

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

RUN apt-get install -y mysql-server
RUN apt-get install -y default-mysql-client

RUN apt-get install -y --no-install-recommends sudo

COPY entrypoint.sh /etc
RUN chmod u+x /etc/entrypoint.sh

ENV UCF_FORCE_CONFFOLD=1

# Start and enable SSH
COPY sshd_config /etc/ssh/
RUN apt-get update \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd

RUN ssh-keygen -A
# RUN addgroup sudo
RUN adduser appuser sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir /run/sshd

# copy the files from the host to the container that we need
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/supervisord.d/nginx.ini /etc/supervisord.d/nginx.ini

# set the sockets and pid files to be writable by the appuser
RUN mkdir -p /var/log/nginx && chown -R appuser:appgroup /var/log/nginx
RUN chown -R appuser:appgroup /var/lib/nginx && touch /run/nginx.pid && chown -R appuser:appgroup /run/nginx.pid

USER appuser

COPY --chown=appuser:appgroup etc/supervisor/conf.d/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY --chown=appuser:appgroup etc/supervisord.d/php-fpm.ini /etc/supervisord.d/php-fpm.ini

# Install CraftCMS code
COPY --chown=appuser:appgroup web/ /app

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install
RUN composer update

EXPOSE 80
EXPOSE 8080
EXPOSE 3306
EXPOSE 8000 2222

ENTRYPOINT ["sh", "/etc/entrypoint.sh"]
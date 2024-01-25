FROM ubuntu:22.04
LABEL Maintainer="Trac Nguyen <npbtrac@yahoo.com>" \
      Description="Container for PHP 7.4 cli"

# Update before installing more
RUN apt update -y

RUN apt install -y --no-install-recommends curl gnupg2 \
    ca-certificates software-properties-common \
    && add-apt-repository -y ppa:ondrej/php

# Remove un-needed things
RUN apt auto-remove -y \
    && apt autoclean \
    && apt clean

# Install PHP
RUN apt-get update \
    && apt install -y php7.4-cli \
    php7.4-bcmath \
    php7.4-common \
    php7.4-curl \
    php7.4-gd \
    php7.4-gettext \
    php7.4-intl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-mysqli \
    php7.4-redis \
    php7.4-soap \
    php7.4-pdo \
    php7.4-pgsql \
    php7.4-sqlite3 \
    php7.4-xml \
    php7.4-zip \
    php7.4-memcached \
    php7.4-pgsql \
    php7.4-imagick \
    php7.4-apcu \
    php7.4-mcrypt \
    php7.4-xdebug

RUN mkdir -p /home/webuser
RUN useradd --no-log-init -r -s /usr/bin/bash -d /home/webuser webuser
RUN chown -R webuser /home/webuser

RUN mkdir -p /app
RUN chown -R webuser:root /app
RUN cd /app

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

USER webuser
WORKDIR /app
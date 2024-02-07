FROM ubuntu:22.04
LABEL Maintainer="Trac Nguyen <npbtrac@yahoo.com>" \
      Description="Container for PHP 8.0 cli"

# Update before installing more
RUN apt update -y

RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends curl gnupg2 \
    ca-certificates software-properties-common \
    && add-apt-repository -y ppa:ondrej/php

# Remove un-needed things
RUN apt auto-remove -y \
    && apt autoclean \
    && apt clean

# Install PHP
RUN apt update -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y zip unzip git curl wget
RUN DEBIAN_FRONTEND=noninteractive apt install -y php8.0-cli \
    php8.0-bcmath \
    php8.0-common \
    php8.0-curl \
    php8.0-gd \
    php8.0-gettext \
    php8.0-intl \
    php8.0-mbstring \
    php8.0-mysql \
    php8.0-mysqli \
    php8.0-redis \
    php8.0-soap \
    php8.0-pdo \
    php8.0-pgsql \
    php8.0-sqlite3 \
    php8.0-xml \
    php8.0-zip \
    php8.0-memcached \
    php8.0-pgsql \
    php8.0-imagick \
    php8.0-apcu \
    php8.0-mcrypt \
    php8.0-xdebug

RUN mkdir -p /app
RUN cd /app

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

# Set home folder for composer to store cached, credentials...
ARG COMPOSER_HOME="/root/.composer"
ENV COMPOSER_HOME="/root/.composer"

WORKDIR /app
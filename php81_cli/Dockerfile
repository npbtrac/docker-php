FROM ubuntu:22.04
LABEL Maintainer="Trac Nguyen <npbtrac@yahoo.com>" \
      Description="Container for PHP 8.1 cli"

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
RUN DEBIAN_FRONTEND=noninteractive apt install -y php8.1-cli \
    php8.1-bcmath \
    php8.1-common \
    php8.1-curl \
    php8.1-gd \
    php8.1-gettext \
    php8.1-intl \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-mysqli \
    php8.1-redis \
    php8.1-soap \
    php8.1-pdo \
    php8.1-pgsql \
    php8.1-sqlite3 \
    php8.1-xml \
    php8.1-zip \
    php8.1-memcached \
    php8.1-pgsql \
    php8.1-imagick \
    php8.1-apcu \
    php8.1-mcrypt \
    php8.1-xdebug

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
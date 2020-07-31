FROM ubuntu:bionic
LABEL maintainer="Trac Nguyen <npbtrac@yahoo.com>"

ENV OS_LOCALE="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y locales && locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
    LANGUAGE=${OS_LOCALE} \
    LC_ALL=${OS_LOCALE}
ENV PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_CONF_DIR=/etc/php/7.4 \
    PHP_DATA_DIR=/var/www/html

RUN \
    BUILD_DEPS='software-properties-common' \
    && dpkg-reconfigure locales \
    # Install common libraries
    && apt-get install --no-install-recommends -y $BUILD_DEPS \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update -y

# Install PHP libraries
RUN apt-get install -y \
    build-essential curl git python libglib2.0-dev wget zip \
    make g++ bzip2 xz-utils pkg-config wget \
    php-cli php-dev php-apcu php-readline php-mbstring php-memcached php-zip \
    php-imagick php-intl php-json php-curl php-gd php-pgsql php-mysql php-pear \
    php-psr php-redis php-xml php-yaml \
    php-phalcon \
    && mkdir -p ${PHP_LOG_DIR} ${PHP_RUN_DIR}
RUN apt-get update -y && apt-get install -y php-memcache php-mongodb php-tidy php-soap

# Todo: Install v8js (crazy one) for PHP 7.4

# Todo: Install ioncube for PHP 7.4
# Install ioncube, it needs to be loaded first so be sure to name it with correct prefix
COPY ioncube_loader_lin_7.4.so /tmp/
#RUN mv /tmp/ioncube_loader_lin_7.4.so /usr/lib/php/20170718/ \
#    && echo "zend_extension=ioncube_loader_lin_7.2.so" > /etc/php/7.2/cli/conf.d/00-ioncube_loader_lin_7.2.ini

# Install phpunit
COPY phpunit.phar /tmp/
RUN cd /tmp \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# wp-cli (need to make it work as root)
COPY wp-cli.phar /root/
RUN echo '#!/bin/bash\n/root/wp-cli.phar --allow-root "$@"' > /usr/bin/wp \
    && chmod +x /root/wp-cli.phar /usr/bin/wp

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer 

# Node and yarn
RUN curl -sL https://deb.nodesource.com/setup_12.x  | bash -
RUN apt-get -y install nodejs
RUN npm install -g yarn

# Making composer faster
RUN mkdir ~/.composer/cache \
    && echo "{}" > ~/.composer/composer.json \
    && composer global require hirak/prestissimo

# Cleaning
RUN apt-get purge -y --auto-remove $BUILD_DEPS \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${PHP_DATA_DIR}
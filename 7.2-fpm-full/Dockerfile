#FROM php:7.2.26-fpm-buster

#LABEL maintainer="Trac Nguyen <npbtrac@yahoo.com>"

#RUN apt-get update && apt-get upgrade -y \
#    && apt-get install -y --no-install-recommends \
#    g++ \
#    libbz2-dev \
#    libc-client-dev \
#    libcurl4-gnutls-dev \
#    libedit2 \
#    libfreetype6-dev \
#    libicu-dev \
#    libjpeg62-turbo-dev \
#    libkrb5-dev \
#    libldap2-dev \
#    libmagickwand-dev \
#    libmcrypt-dev \
#    libmemcached-dev \
#    libpq-dev \
#    libsqlite3-dev \
#    libssl-dev \
#    libreadline-dev \
#    libxslt1-dev \
#    libyaml-dev \
#    memcached \
#    wget \
#    unzip \
#    zlib1g-dev \
#    && docker-php-ext-configure gd \
#    --with-freetype-dir=/usr/include/ \
#    --with-jpeg-dir=/usr/include/ \
#    --with-png-dir=/usr/include/ \
#    && docker-php-ext-install -j$(nproc) gd \
#    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
#    && docker-php-ext-install -j$(nproc) imap \
#    && docker-php-ext-configure intl \
#    && docker-php-ext-install -j$(nproc) intl \
#    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
#    && docker-php-ext-install ldap \
#    && docker-php-ext-install -j$(nproc) \
#    bcmath \
#    bz2 \
#    calendar \
#    exif \
#    gettext \
#    mysqli \
#    opcache \
#    pdo_mysql \
#    pdo_pgsql \
#    pgsql \
#    soap \
#    sockets \
#    xmlrpc \
#    xsl \
#    zip \
#    && pecl install memcached && docker-php-ext-enable memcached \
#    && pecl install mongodb && docker-php-ext-enable mongodb \
#    && pecl install phalcon && docker-php-ext-enable psr phalcon \
#    && pecl install redis && docker-php-ext-enable redis \
#    && pecl install xdebug && docker-php-ext-enable xdebug \
#    && pecl install yaml && docker-php-ext-enable yaml \
#    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
#    && pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt \
#    && docker-php-source delete \
#    && rm -rf /var/lib/apt/lists/* \
#    && rm -rf /tmp/* /var/tmp/*
#
## Prepare config files
#COPY php-custom.ini /usr/local/etc/php/conf.d/custom.ini
#COPY fpm.conf /usr/local/etc/php-fpm.d/zzz-fpm.conf
#
#RUN apt-get update && apt-get upgrade -y \
#    && apt-get install -y --no-install-recommends \
#    build-essential \
#    git \
#    libglib2.0-dev \
#    patchelf \
#    python
#
## Install ioncube
#COPY ioncube_loader_lin_7.2.so /tmp/
#RUN cd /tmp \
#    && mv ioncube_loader_lin_7.2.so /usr/local/lib/php/extensions/* \
#    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube_loader_lin_7.2.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_7.2.ini
#
## Install phpunit
#COPY phpunit.phar /tmp/
#RUN cd /tmp \
#    && mv phpunit.phar /usr/local/bin/phpunit \
#    && chmod +x /usr/local/bin/phpunit
#
## Install composer
#COPY composer.phar /tmp/
#RUN cd /tmp \
#    && mv composer.phar /usr/local/bin/composer \
#    && chmod +x /usr/local/bin/composer
#
## https://github.com/hirak/prestissimo
#RUN composer global require hirak/prestissimo
#
## Install wp-cli
#COPY wp-cli.phar /tmp/
#RUN cd /tmp \
#    && mv wp-cli.phar /usr/local/bin/wp \
#    && chmod +x /usr/local/bin/wp
#
## Prepare config files
#COPY php-custom.ini /usr/local/etc/php/conf.d/custom.ini
#COPY fpm.conf /usr/local/etc/php-fpm.d/zzz-fpm.conf
#
## V8js
## Install depot_tools first (needed for source checkout)
#RUN cd /tmp && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
#ENV PATH /tmp/depot_tools:$PATH
#
## Download v8
#RUN cd /tmp && fetch v8
#RUN cd /tmp/v8 && git checkout 7.5.289 && gclient sync
#
## Setup GN
#RUN cd /tmp/v8 && tools/dev/v8gen.py -vv x64.release -- is_component_build=true
#
## Build
#RUN cd /tmp/v8 && ninja -C out.gn/x64.release/

## Install to /opt/v8/
#RUN mkdir -p /opt/v8/{lib,include}
#RUN cd /tmp/v8 \
#    && cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin out.gn/x64.release/icudtl.dat /opt/v8/lib/
#RUN cd /tmp/v8 && cp -R include/* /opt/v8/include/
#RUN for A in /opt/v8/lib/*.so; do patchelf --set-rpath '$ORIGIN' $A; done
#
## Install v8js
#RUN cd /tmp && git clone https://github.com/phpv8/v8js.git
#RUN cd /tmp/v8js && phpize
#RUN cd /tmp/v8js && ./configure --with-v8js=/opt/v8
#RUN cd /tmp/v8js && make
#RUN cd /tmp/v8js && make test
#RUN cd /tmp/v8js && make install
#RUN echo extension=v8js.so >> /usr/local/etc/php/conf.d/v8js.ini

# Set working dir
#WORKDIR /var/www/html


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
    PHP_CONF_DIR=/etc/php/7.2 \
    PHP_DATA_DIR=/var/lib/php

RUN \
    BUILD_DEPS='software-properties-common' \
    && dpkg-reconfigure locales \
    # Install common libraries
    && apt-get install --no-install-recommends -y $BUILD_DEPS \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

# Install PHP libraries
# php7.2-mcrypt not support and move to PECL. Use extension Sodium: http://php.net/manual/book.sodium.php
RUN apt-get install -y \
    curl php7.2-fpm php7.2-cli php7.2-readline php7.2-mbstring php7.2-memcached php7.2-zip php7.2-intl \
    php7.2-json php7.2-xml php7.2-curl php7.2-gd php7.2-pgsql php7.2-mysql php-pear \
    php7.2-psr php7.2-redis php7.2-xdebug php7.2-yaml \
    && mkdir -p ${PHP_LOG_DIR} ${PHP_RUN_DIR}

# Cleaning
RUN apt-get purge -y --auto-remove $BUILD_DEPS \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./php-fpm.conf ${PHP_CONF_DIR}/fpm/php-fpm.conf
COPY ./www.conf ${PHP_CONF_DIR}/fpm/pool.d/www.conf
COPY ./php-custom.ini ${PHP_CONF_DIR}/fpm/conf.d/php-custom.ini

RUN sed -i "s~PHP_RUN_DIR~${PHP_RUN_DIR}~g" ${PHP_CONF_DIR}/fpm/php-fpm.conf \
    && sed -i "s~PHP_LOG_DIR~${PHP_LOG_DIR}~g" ${PHP_CONF_DIR}/fpm/php-fpm.conf \
    && chown www-data:www-data ${PHP_DATA_DIR} -Rf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --version=1.8.4 --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

EXPOSE 9000

VOLUME ["${PHP_RUN_DIR}", "${PHP_DATA_DIR}"]
CMD ["/usr/sbin/php-fpm7.2"]
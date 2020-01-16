FROM php:7.2.26-cli-buster

LABEL maintainer="Trac Nguyen <npbtrac@yahoo.com>"

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    g++ \
    git \
    libbz2-dev \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libfreetype6-dev \
    libglib2.0-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libldb-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libyaml-dev \
    libzip-dev \
    memcached \
    python \
    wget \
    unzip \
    zlib1g-dev \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gettext \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    sockets \
    xmlrpc \
    xsl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install ldap \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && pecl install memcached && docker-php-ext-enable memcached \
    && pecl install mongodb && docker-php-ext-enable mongodb \
    && pecl install phalcon && docker-php-ext-enable psr phalcon \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install yaml && docker-php-ext-enable yaml \
    && yes '' | pecl install imagick && docker-php-ext-enable imagick \
    && docker-php-source delete \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

# Install ioncube
RUN cd /tmp \
    && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_7.2.so /usr/local/lib/php/extensions/* \
    && rm -Rf ioncube.tar.gz ioncube \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20170718/ioncube_loader_lin_7.2.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_7.2.ini

# Install depot_tools first (needed for source checkout)
RUN cd /tmp && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH /tmp/depot_tools:$PATH

# Download v8
RUN cd /tmp && fetch v8
RUN cd /tmp/v8 && gclient sync

# Setup GN
RUN cd /tmp/v8 && tools/dev/v8gen.py -vv x64.release -- is_component_build=true

# Build
RUN cd /tmp/v8 && ninja -C out.gn/x64.release/

# Install to /opt/v8/
RUN mkdir -p /opt/v8/lib
RUN mkdir /opt/v8/include
RUN cd /tmp/v8 && cp out.gn/x64.release/lib*.so out.gn/x64.release/*_blob.bin /opt/v8/lib/
RUN cd /tmp/v8 && cp -R include/* /opt/v8/include/

# Install v8js
RUN cd /tmp && git clone https://github.com/phpv8/v8js.git
RUN cd /tmp/v8js && phpize
RUN cd /tmp/v8js && ./configure --with-v8js=/opt/v8
RUN cd /tmp/v8js && make
RUN cd /tmp/v8js && make test
RUN cd /tmp/v8js && make install
RUN echo extension=v8js.so >> /usr/local/etc/php/conf.d/v8js.ini

# Install phpunit
RUN curl -L -o /usr/local/bin/phpunit https://phar.phpunit.de/phpunit.phar
RUN chmod +x /usr/local/bin/phpunit

# Install composer
RUN curl -sS "https://getcomposer.org/installer" | php
RUN mv composer.phar /usr/local/bin/composer

# https://github.com/hirak/prestissimo
RUN composer global require hirak/prestissimo

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Set working dir
WORKDIR /var/www/html

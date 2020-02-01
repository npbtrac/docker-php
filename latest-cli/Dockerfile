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
    build-essential curl git python libglib2.0-dev wget \
    make g++ bzip2 xz-utils pkg-config wget \
    php-cli php-dev php-readline php-mbstring php-memcached php-zip \
    php-imagick php-intl php-json php-curl php-gd php-pgsql php-mysql php-pear \
    php-psr php-redis php-xml php-yaml \
    php-phalcon \
    && mkdir -p ${PHP_LOG_DIR} ${PHP_RUN_DIR}
RUN apt-get update -y && apt-get install -y php-memcache php-mongodb php-tidy php-soap

# Todo: Install v8js (crazy one) for PHP 7.4

# Todo: Install ioncube for PHP 7.4

# Cleaning
RUN apt-get purge -y --auto-remove $BUILD_DEPS \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install phpunit
COPY phpunit.phar /tmp/
RUN cd /tmp \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --version=1.8.4 --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer \
    && composer global require hirak/prestissimo \
    && composer global require codeception/codeception --dev

# Create aliases
# codecept
RUN echo '#!/bin/bash\n/root/.composer/vendor/bin/codecept "$@"' > /usr/bin/codecept \
    && chmod +x /usr/bin/codecept

# wp-cli (need to make it work as root)
COPY wp-cli.phar /root/
RUN echo '#!/bin/bash\n/root/wp-cli.phar --allow-root "$@"' > /usr/bin/wp \
    && chmod +x /root/wp-cli.phar /usr/bin/wp

WORKDIR ${PHP_DATA_DIR}
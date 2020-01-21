FROM npbtrac/php:7.4-fpm

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libglib2.0-dev \
    python

# Todo: Extension ioncube is not available for PHP 7.4 so far

# Todo: v8js extension currently not working with buster, stop at configure

# Install phpunit
COPY phpunit.phar /tmp/
RUN cd /tmp \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# Install wp-cli
COPY wp-cli.phar /tmp/
RUN cd /tmp \
    && mv wp-cli.phar /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

# Install composer
COPY composer.phar /tmp/
RUN cd /tmp \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# https://github.com/hirak/prestissimo
RUN composer global require hirak/prestissimo

RUN composer global require codeception/codeception --dev

# Prepare config files
COPY php-custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY fpm.conf /usr/local/etc/php-fpm.d/zzz-fpm.conf

# Set working dir
WORKDIR /var/www/html
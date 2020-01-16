FROM npbtrac/php:7.4-fpm

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libglib2.0-dev \
    python

# Todo: Extension ioncube is not available for PHP 7.4 so far

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

# Prepare config files
COPY php-custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY fpm.conf /usr/local/etc/php-fpm.d/zzz-fpm.conf

# Set working dir
WORKDIR /var/www/html
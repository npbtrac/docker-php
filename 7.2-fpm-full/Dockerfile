FROM npbtrac/php:7.2-fpm

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libglib2.0-dev \
    python

# Install ioncube
COPY ../common/ioncube_loader_lin_7.2.so /tmp/
RUN cd /tmp \
    && mv ioncube_loader_lin_7.2.so /usr/local/lib/php/extensions/* \
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
COPY ../common/phpunit.phar /tmp/
RUN cd /tmp \
    && mv phpunit.phar /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# Install composer
COPY ../common/composer.phar /tmp/
RUN cd /tmp \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# https://github.com/hirak/prestissimo
RUN composer global require hirak/prestissimo

# Install wp-cli
COPY ../common/wp-cli.phar /tmp/
RUN cd /tmp \
    && mv wp-cli.phar /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

# Prepare config files
COPY php-custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY fpm.conf /usr/local/etc/php-fpm.d/zzz-fpm.conf

# Set working dir
WORKDIR /var/www/html
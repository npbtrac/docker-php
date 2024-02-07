FROM php:7.3-fpm-bullseye

# Get packages that we need in container
RUN apt-get update -q -y \
    && apt-get install -q -y --no-install-recommends \
        ca-certificates \
        curl \
        acl \
        sudo \
# Disable expired Let's Encrypt certificate
    && sed -i '/mozilla\/DST_Root_CA_X3.crt/ s/./!&/' /etc/ca-certificates.conf \
    && update-ca-certificates --verbose \
# Needed for the php extensions we enable below
    && apt-get install -q -y --no-install-recommends \
        libfreetype6 \
        libjpeg62-turbo \
        libxpm4 \
        libpng16-16 \
        libxslt1.1 \
        libmemcachedutil2 \
        libzip4 \
        imagemagick \
        libpq5 \ 
# git & unzip needed for composer, unless we document to use dev image for composer install
# unzip needed due to https://github.com/composer/composer/issues/4471
        unzip \
        git \
# packages useful for dev
        less \
        mariadb-client \
        vim \
        wget \
        tree \
        gdb-minimal \
    && rm -rf /var/lib/apt/lists/*

# Install and configure php plugins
RUN set -xe \
    && buildDeps=" \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libxpm-dev \
        libpng-dev \
        libxslt1-dev \
        libmemcached-dev \
        libzip-dev \
        libxml2-dev \
        libmagickwand-dev \
        libpq-dev \
    " \
	&& apt-get update -q -y && apt-get install -q -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/*

# Extract php source and install missing extensions
RUN docker-php-source extract \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-xpm-dir=/usr/include/ --enable-gd-jis-conv \
    && docker-php-ext-install exif gd mbstring intl xsl zip mysqli pdo_mysql pdo_pgsql pgsql soap bcmath \
    && docker-php-ext-enable opcache \
    && cp /usr/src/php/php.ini-production ${PHP_INI_DIR}/php.ini

# Install imagemagick
RUN for i in $(seq 1 3); do pecl install -o imagick-3.7.0 && s=0 && break || s=$? && sleep 1; done; (exit $s) \
    && docker-php-ext-enable imagick
# Install xdebug
# RUN for i in $(seq 1 3); do echo yes | pecl install -o "xdebug-3.1.5" && s=0 && break || s=$? && sleep 1; done; (exit $s) \
# Install blackfire: https://blackfire.io/docs/integrations/docker
# RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
#     && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
#     && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
#     && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
#     && rm -f /tmp/blackfire-probe.tar.gz

# Install igbinary (for more efficient serialization in redis/memcached)
RUN for i in $(seq 1 3); do pecl install -o igbinary-3.2.15 && s=0 && break || s=$? && sleep 1; done; (exit $s) \
    && docker-php-ext-enable igbinary

# Install redis (manualy build in order to be able to enable igbinary)
RUN for i in $(seq 1 3); do pecl install -o --nobuild redis-4.2.0 && s=0 && break || s=$? && sleep 1; done; (exit $s) \
    && cd "$(pecl config-get temp_dir)/redis" \
    && phpize \
    && ./configure --enable-redis-igbinary \
    && make \
    && make install \
    && docker-php-ext-enable redis \
    && cd - 

# Install memcached (manualy build in order to be able to enable igbinary)
RUN for i in $(seq 1 3); do echo no | pecl install -o --nobuild memcached-3.1.5 && s=0 && break || s=$? && sleep 1; done; (exit $s) \
    && cd "$(pecl config-get temp_dir)/memcached" \
    && phpize \
    && ./configure --enable-memcached-igbinary \
    && make \
    && make install \
    && docker-php-ext-enable memcached \
    && cd -

# Delete source & builds deps so it does not hang around in layers taking up space
RUN pecl clear-cache \
    && rm -Rf "$(pecl config-get temp_dir)/*" \
    && docker-php-source delete \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps

# Set timezone
RUN echo "UTC" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# Set pid file to be able to restart php-fpm
RUN sed -i "s@^\[global\]@\[global\]\n\npid = /run/php-fpm.pid@" ${PHP_INI_DIR}-fpm.conf

COPY ./php73_web/conf.d/xdebug.ini ${PHP_INI_DIR}/conf.d/xdebug.ini.disabled

RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 128M/" /usr/local/etc/php/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 128M/" /usr/local/etc/php/php.ini

RUN apt-get update -y
RUN apt-get install -y nginx zip unzip git

# As application is put in as volume we do all needed operation on run
COPY ./php73_web/scripts /scripts

# Add some custom config
RUN mkdir -p /etc/nginx/site-opts.d/
RUN mkdir -p /etc/nginx/server-opts.d/

# Putting config files to their locations
COPY ./config/nginx/http.conf /etc/nginx/site-opts.d/http.conf
COPY ./config/nginx/https.conf /etc/nginx/site-opts.d/https.conf

COPY ./php73_web/server-opts.d/ /etc/nginx/server-opts.d/
COPY ./php73_web/default.conf /etc/nginx/sites-available/default
COPY ./php73_web/conf.d/php.ini ${PHP_INI_DIR}/conf.d/php.ini

RUN chmod 755 /scripts/*.sh

### Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

# Set home folder for composer to store cached, credentials...
ARG COMPOSER_HOME="/root/.composer"
ENV COMPOSER_HOME="/root/.composer"

# Needed for docker-machine
RUN usermod -u 1000 www-data

WORKDIR /var/www/html

ENTRYPOINT ["/scripts/start-services.sh"]

EXPOSE 9000
EXPOSE 80
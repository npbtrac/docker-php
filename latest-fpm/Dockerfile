FROM npbtrac/php:latest-cli

ENV PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_CONF_DIR=/etc/php/7.4 \
    PHP_DATA_DIR=/var/www/html

RUN apt-get update -y \
    && apt-get install -y php-fpm php-xdebug \
    && mkdir -p ${PHP_LOG_DIR} ${PHP_RUN_DIR}

COPY ./php-fpm.conf ${PHP_CONF_DIR}/fpm/php-fpm.conf
COPY ./www.conf ${PHP_CONF_DIR}/fpm/pool.d/www.conf
COPY ./php-custom.ini ${PHP_CONF_DIR}/fpm/conf.d/php-custom.ini

RUN sed -i "s~PHP_RUN_DIR~${PHP_RUN_DIR}~g" ${PHP_CONF_DIR}/fpm/php-fpm.conf \
    && sed -i "s~PHP_LOG_DIR~${PHP_LOG_DIR}~g" ${PHP_CONF_DIR}/fpm/php-fpm.conf \
    && chown www-data:www-data ${PHP_DATA_DIR} -Rf

# Set working dir
WORKDIR ${PHP_DATA_DIR}

# Start php-fpm servic
EXPOSE 9000
CMD ["/usr/sbin/php-fpm7.4"]
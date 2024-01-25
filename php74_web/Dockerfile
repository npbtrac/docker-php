FROM serversideup/php:7.4-fpm-nginx
LABEL Maintainer="Trac Nguyen <npbtrac@yahoo.com>" \
      Description="Container for hosting web using PHP 7.4 (FPM) with Nginx based on ServerSideUp https://hub.docker.com/layers/serversideup/php/7.4-fpm-nginx/images/sha256-cf8507d60bc4655b216b256bcde0d2deb023334a06101105234e04b9176703f8?context=explore"

ENV SSL_MODE="mixed"

# Install packages
RUN apt update -y && apt upgrade -y

# Install PHP packages
RUN apt install -y php7.4-memcached php7.4-pgsql php7.4-imagick php7.4-apcu php7.4-mcrypt

# Putting config files to their locations
COPY ./config/nginx/http.conf /etc/nginx/site-opts.d/http.conf
COPY ./config/nginx/https.conf /etc/nginx/site-opts.d/https.conf

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');"
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# Working files
COPY ./public/ /var/www/html/public

# USER webuser

WORKDIR /var/www/html/

#!/bin/bash

service nginx start
sh /scripts/php-fpm.sh php-fpm

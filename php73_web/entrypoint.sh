#!/bin/bash

service php7.3-fpm start
service nginx start

echo "Web server is ready"

tail -f /dev/null
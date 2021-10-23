#!/bin/sh

echo 'Container ready'


composer install --prefer-dist --no-interaction --no-scripts --ignore-platform-reqs;

# run php-fpm
exec /usr/sbin/php-fpm8.0 -O

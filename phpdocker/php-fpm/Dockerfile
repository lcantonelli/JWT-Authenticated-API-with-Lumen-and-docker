FROM phpdockerio/php80-fpm:latest
WORKDIR "/data"

RUN apt-get update; \
    apt-get -y --no-install-recommends install \
        git \ 
        php8.0-memcached \ 
        php8.0-mysql \ 
        php8.0-redis \ 
        php8.0-xdebug \ 
        php8.0-yaml \
        php8.0-sqlite3; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

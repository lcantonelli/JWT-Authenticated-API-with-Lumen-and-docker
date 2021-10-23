FROM phpdockerio/php80-fpm:latest

LABEL Maintainer="lcantonelli labs" \
      Description="api-base-php-fpm is an alternative PHP FastCGI implementation with some additional features to running API base." \
      org.label-schema.name="lcantonelli/JWT-Authenticated-API-with-Lumen-and-docker" \
      org.label-schema.description="lcantonelli labs" \
      org.label-schema.vcs-url="https://github.com/lcantonelli/JWT-Authenticated-API-with-Lumen-and-docker" \
      org.label-schema.schema-version="0.0.1"

WORKDIR /data

#If set to 1, this env disables the warning about running commands as root/super user.
ARG COMPOSER_ALLOW_SUPERUSER=1
ARG LARAVEL_ENV=${LARAVEL_ENV:-prod}
ARG USER_ID=${USER_ID:-33}
ARG GROUP_ID=${GROUP_ID:-33}

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

RUN ( \
        cd /tmp \
        && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
        && php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"\
        && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
        && php -r "unlink('composer-setup.php');" \
    ) \
    && rm -rf /tmp/* /var/cache/* /var/tmp/*

COPY  . .

RUN set -x \
    && if [ "$LARAVEL_ENV" != "prod" ]; then \
        composer install --prefer-dist --no-interaction --no-scripts --ignore-platform-reqs; \
    else \
        composer install --prefer-dist --no-interaction --no-scripts --no-dev --ignore-platform-reqs; \
    fi

ENTRYPOINT ["/data/entrypoint_prod.sh"]

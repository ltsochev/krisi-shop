FROM --platform=linux/amd64 wordpress:php8.2-fpm-alpine

RUN apk --update add zip unzip gcc make g++ zlib-dev autoconf yarn automake libpng-dev alpine-sdk nasm net-tools linux-headers
RUN set -xe; \
  apk --no-cache update && apk --no-cache upgrade \
  && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
  && apk add --no-cache php82-pdo_mysql \
  && docker-php-ext-install pdo_mysql \
  && pecl install redis \
  && docker-php-ext-enable redis  \
  && apk add --no-cache libc6-compat openssl1.1-compat \
  # Cleanup build deps
  && apk del .build-deps \
  && rm -rf /tmp/* /var/cache/apk/*

COPY ./config/entrypoint.sh /usr/bin/entrypoint.sh

WORKDIR /var/www/html

COPY plugins ./wp-content/plugins

RUN chmod 777 /usr/bin/entrypoint.sh
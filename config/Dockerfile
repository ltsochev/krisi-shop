FROM wordpress:php8.2-fpm-alpine

RUN apk add --no-cache mysql-client bash unzip

RUN set -xe; \
  apk --no-cache update && apk --no-cache upgrade \
  && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
  && pecl install redis \
  && docker-php-ext-enable redis  \
  && apk add --no-cache libc6-compat openssl1.1-compat \
  # Cleanup build deps
  && apk del .build-deps \
  && rm -rf /tmp/* /var/cache/apk/*

RUN docker-php-ext-install pdo pdo_mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

RUN curl -o wp-graphql-woocommerce.zip -fL https://github.com/wp-graphql/wp-graphql-woocommerce/releases/download/v0.13.0/wp-graphql-woocommerce.zip \
  && unzip wp-graphql-woocommerce.zip -d /usr/src/wp-graphql-woocommerce \
  && rm -f wp-graphql-woocommerce.zip \
  && chown -R www-data:www-data /usr/src/wp-graphql-woocommerce

COPY ./config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

COPY ./config/php.ini /usr/local/etc/php/conf.d/kstore-php.ini

COPY --chown=www-data:www-data ./themes /usr/src/themes

RUN chmod +x /usr/local/bin/wp
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN chown -R www-data:www-data /var/www/html

USER www-data

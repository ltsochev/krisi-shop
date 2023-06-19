FROM wordpress:php8.2-fpm-alpine

ARG SITE_URL
ENV SITE_URL=${SITE_URL:-'http://localhost'}

RUN apk add --no-cache mysql-client bash

RUN docker-php-ext-install pdo pdo_mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/wp
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN chown -R www-data:www-data /var/www/html

USER www-data

# Copy the Woocommerce GraphQL plugin 
COPY --chown=www-data:www-data plugins/wp-graphql-woocommerce /var/www/html/wp-content/plugins/wp-graphql-woocommerce

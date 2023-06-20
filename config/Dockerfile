FROM wordpress:php8.2-fpm-alpine

RUN apk add --no-cache mysql-client bash unzip

RUN docker-php-ext-install pdo pdo_mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN curl -o wp-graphql-woocommerce.zip -fL https://github.com/wp-graphql/wp-graphql-woocommerce/releases/download/v0.13.0/wp-graphql-woocommerce.zip \
    && unzip wp-graphql-woocommerce.zip -d /usr/src/wp-graphql-woocommerce \
    && rm -f wp-graphql-woocommerce.zip

COPY ./config/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/wp
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN chown -R www-data:www-data /var/www/html

USER www-data


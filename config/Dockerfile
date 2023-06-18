FROM wordpress:php8.2-fpm-alpine

RUN apk add --no-cache mysql-client bash

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./config/entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/wp
RUN chmod +x /usr/bin/entrypoint.sh

RUN chown -R www-data:www-data /var/www/html

USER www-data

COPY --chown=www-data:www-data . /var/www/html

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD [ "php-fpm" ]
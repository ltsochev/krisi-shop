#!/bin/bash
# Trick to get host.docker.internal working on Linux Docker
# From https://dev.to/bufferings/access-host-from-a-docker-container-4099
HOST_DOMAIN="host.docker.internal"
ping -q -c1 $HOST_DOMAIN > /dev/null 2>&1
if [ $? -ne 0 ]; then
    HOST_IP=$(route | awk 'FNR==3 {print $2}')
    echo -e "$HOST_IP\t$HOST_DOMAIN" >> /etc/hosts
fi

# Add a custom wait-for-db loop
set -e

host="$WORDPRESS_DB_HOST"
until mysqladmin ping -h "$host" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" > /dev/null 2>&1; do
    >&2 echo "Database is unavailable - sleeping"
    sleep 1
done

>&2 echo "Database is up - continuing with execution"

# Run WordPress CLI commands
wp core version
wp core install --path=/var/www/html --url=localhost --title="$WORDPRESS_TITLE" --admin_user="$WORDPRESS_USER" --admin_password="$WORDPRESS_PASSWORD" --admin_email="$WORDPRESS_EMAIL"
wp plugin install woocommerce --activate --allow-root --version="$WOOCOMMERCE_VERSION"
wp plugin install wp-graphql --activate --allow-root --version=1.14.4
wp plugin install wordpress-seo --activate --allow-root --version=20.9
wp plugin install instantio --activate --allow-root --version=2.5.25
wp plugin install printful-shipping-for-woocommerce --activate --allow-root --version=2.2.2
wp plugin install woocommerce-gateway-stripe --activate --allow-root --version="$STRIPE_GATEWAY_VERSION"
wp plugin activate wp-graphql-woocommerce

# Copy in original PHP docker-php-entrypoint
if [ "${1#-}" != "$1" ]; then
    set -- apache2-foreground "$@"
fi

exec "$@"

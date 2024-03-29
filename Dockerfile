FROM php:7.4-apache

# Встановлення необхідних пакетів, включаючи oniguruma
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libonig-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libxml2-dev \
        libxmlrpc-c++8-dev \
        libsnmp-dev \
        libbz2-dev \
        libicu-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libzip-dev \
        libmemcached-dev \
        zlib1g-dev \
        libldap2-dev \
        unixodbc-dev \
        gawk \
    && rm -rf /var/lib/apt/lists/*

# Configure and install additional PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql mbstring xmlrpc snmp bcmath opcache sockets

# Не забудьте розпочати сервер Apache
CMD ["apache2-foreground"]

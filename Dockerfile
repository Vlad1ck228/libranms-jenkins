# Використовуємо офіційний образ PHP 7.4 з Apache
FROM php:7.4-apache

# Встановлюємо деякі залежності
RUN apt-get update && \
    apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    libxml2-dev \
    mariadb-client \
    curl \
    git \
    unzip \
    cron \
    rrdtool \
    librrds-perl \
    snmp \
    fping \
    whois \
    mtr-tiny \
    ipmitool \
    python3-pip \
    python3-yaml \
    mariadb-client \
    apache2 \
    apache2-utils \
    apache2-dev \
    supervisor \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Встановлюємо Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Встановлюємо залежності PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql mbstring xmlrpc snmp bcmath opcache sockets

# Встановлюємо Librenms
WORKDIR /var/www/html
RUN git clone https://github.com/librenms/librenms.git .

# Встановлюємо права доступу та виконуємо міграції
RUN chmod 775 . && \
    mkdir -p logs rrd includes && \
    chown -R www-data:www-data /var/www/html && \
    setfacl -d -m g::rwx logs rrd && \
    setfacl -d -m g::rwx storage && \
    cp .env.example .env && \
    composer install --no-dev --optimize-autoloader

# Копіюємо конфігураційний файл Apache
COPY apache2.conf /etc/apache2/apache2.conf

# Встановлюємо Apache mod_rewrite
RUN a2enmod rewrite

# Встановлюємо конфігураційний файл Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Відкриваємо порти
EXPOSE 80/tcp 443/tcp

# Команда для запуску Supervisor
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

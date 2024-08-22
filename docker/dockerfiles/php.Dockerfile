FROM php:8.3-fpm AS php

WORKDIR /usr/src

ARG user
ARG uid

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libc6 \
    zip \
    unzip \
    supervisor \
    default-mysql-client

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

RUN pecl install redis

COPY --from=composer:2.5.8 /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

COPY ./docker/deployment/bin/wait-for-it.sh /usr/wait-for-it_tmp.sh
COPY ./docker/deployment/bin/update.sh /usr/update_tmp.sh
COPY ./docker/deployment/config/php-fpm/php-prod.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/deployment/config/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./src .

RUN tr -d '\015' </usr/update_tmp.sh >/usr/update.sh && \
    tr -d '\015' </usr/wait-for-it_tmp.sh >/usr/wait-for-it.sh && \
    rm /usr/update_tmp.sh && \
    rm /usr/wait-for-it_tmp.sh && \
    #chown -R $user:$user /usr/src && \
    chmod -R 775 ./storage ./bootstrap/cache && \
    chmod +x /usr/update.sh && \
    chmod +x /usr/wait-for-it.sh

USER $user

FROM php AS worker
COPY ./docker/deployment/config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/bin/sh", "-c", "supervisord -c /etc/supervisor/conf.d/supervisor.conf"]

FROM php AS scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]
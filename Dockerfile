FROM php:7.0-fpm
MAINTAINER Jonathan Garbee <jonathan@garbee.me>
# Install modules
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        libicu-dev \
        postgresql-client-9.4 \
        libsqlite3-dev \
        unzip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install iconv mcrypt pgsql bcmath mbstring zip opcache pdo intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd pdo_sqlite pdo_pgsql
CMD ["php-fpm"]

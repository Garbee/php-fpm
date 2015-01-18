FROM ubuntu:14.04
MAINTAINER Jonathan Garbee <jonathan@garbee.me>

RUN echo 'deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main' | tee -a /etc/apt/sources.list.d/php.list 

RUN echo 'deb-src http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main' | tee -a /etc/apt/sources.list.d/php.list 

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C

RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y php5-fpm \
    php5-gd \
    php5-curl \
    php5-mcrypt \
    php5-imagick \
    php5-pgsql \
    php5-readline \
    php5-json

RUN php5enmod mcrypt

COPY php-fpm.conf /usr/local/etc/
COPY php.ini /etc/php5/fpm/
WORKDIR /var/www/html

EXPOSE 9000
CMD ["php-fpm"]

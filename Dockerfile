FROM debian:jessie
MAINTAINER Jonathan Garbee <jonathan@garbee.me>

RUN apt-get update && apt-get install -y autoconf file g++ gcc libc-dev make pkg-config re2c ca-certificates curl libpcre3 librecode0 libsqlite3-0 libxml2 --no-install-recommends && rm -r /var/lib/apt/lists/*

ENV PHP_INI_DIR /usr/local/etc/php
RUN mkdir -p $PHP_INI_DIR/conf.d

ENV PHP_VERSION 7.0.0alpha1

RUN buildDeps=" \
		$PHP_EXTRA_BUILD_DEPS \
		bzip2 \
		libcurl4-openssl-dev \
		libpcre3-dev \
		libreadline6-dev \
		librecode-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		libpng12-dev \
		libjpeg62-turbo-dev \
		libmcrypt-dev \
		postgresql-server-dev-all \
	" \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& curl -SL "https://downloads.php.net/~ab/php-$PHP_VERSION.tar.bz2" -o php.tar.bz2 \
	&& mkdir -p /usr/src/php \
	&& tar -xof php.tar.bz2 -C /usr/src/php --strip-components=1 \
	&& rm php.tar.bz2* \
	&& cd /usr/src/php \
	&& ./configure \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		--disable-cgi \
		--with-curl \
		--with-openssl \
		--with-pcre \
		--with-readline \
		--with-recode \
		--with-zlib \
		--enable-bcmath \
		--enable-exif \
		--enable-mbstring \
		--with-gd \
		--with-mcrypt \
		--with-pgsql \
		--enable-zip \
		--with-pdo-pgsql \
		--enable-fpm \
	&& make -j"$(nproc)" \
	&& make install \
	&& { find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; } \
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps \
	&& make clean


WORKDIR /var/www/html
COPY php-fpm.conf /usr/local/etc/

EXPOSE 9000
CMD ["php-fpm"]

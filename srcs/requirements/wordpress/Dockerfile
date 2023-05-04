FROM alpine:3.16

# https://make.wordpress.org/hosting/handbook/server-environment/
# https://pkgs.org/
RUN apk update && apk upgrade && apk add --no-cache \
  php8 \
  php8-fpm \
  php8-mysqli \
  php8-opcache \
  php8-bcmath \
  php8-exif \
  php8-gd \
  php8-curl \
  php8-json \
  php8-mbstring \
  php8-intl \
  php8-xml \
  php8-zip \
  php8-openssl \
  php8-pear \
  php8-phar \
  php8-zip \
  php8-zlib \
  mariadb-client \
  curl \
  ca-certificates \
  tar \
  wget \
  bash \
  less

RUN adduser -S nginx && addgroup -S nginx
# fastcgiの処理に関連する設定
COPY ./conf/php-fpm.conf /etc/php8/php-fpm.conf
COPY ./conf/www.conf /etc/php8/php-fpm.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp \
  && chmod +x /usr/local/bin/wp

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

COPY ./tools/wordpress-6.2.tar.gz /tmp/
COPY ./tools/index.html /tmp/
RUN chmod -R 777 /tmp/

ENTRYPOINT [ "setup.sh" ]

CMD [ "php-fpm8", "--nodaemonize" ]
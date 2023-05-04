FROM alpine:3.16

RUN apk update && apk upgrade && apk add --no-cache \
  nginx \
  openssl

# open ssl certificate
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
  -out /etc/nginx/ssl/inception.crt \
  -keyout /etc/nginx/ssl/inception.key \
  -subj "/C=JP/ST=Tokyo/L=city/O=42tokyo/CN=syamashi.42.fr"

# nginx
RUN mkdir -p /run/nginx
COPY ./conf/default.conf /etc/nginx/http.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
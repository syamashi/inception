FROM alpine:3.16

RUN apk update && apk upgrade && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-common && \
    rm -rf /var/cache/apk/*

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Copy the custom configuration file for mariadb
# 1. /etc/my.cnf
# 2. /etc/mysql/my.cnf
# 3. /etc/my.cnf.d/*.cnf
# 4. $MYSQL_HOME/my.cnf
# defaultでmariadb-server.cnfが存在しているので、上書き
COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

ENTRYPOINT [ "setup.sh" ]

CMD [ "/usr/bin/mysqld", "--user=mysql", "--console" ]
FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    unzip \
    libaio1 \
    wget \
    gnupg2 \
    && docker-php-ext-install mysqli

RUN mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    echo /opt/oracle/instantclient_21_13 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_13
ENV ORACLE_HOME=/opt/oracle/instantclient_21_13

RUN pecl install oci8-3.2.1 <<EOF
instantclient,/opt/oracle/instantclient_21_13
EOF

RUN echo "extension=oci8.so" > /usr/local/etc/php/conf.d/oci8.ini

COPY public/ /var/www/html/

FROM php:8.2-apache

# Instalar dependências básicas
RUN apt-get update && apt-get install -y \
    unzip \
    libaio1 \
    wget \
    gnupg2 \
    libzip-dev \
    zip \
    && docker-php-ext-install mysqli

# Baixar e configurar Oracle Instant Client
RUN mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    echo /opt/oracle/instantclient_21_13 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_13
ENV ORACLE_HOME=/opt/oracle/instantclient_21_13

# Instalar OCI8 com caminho correto para o Instant Client
RUN echo "instantclient,/opt/oracle/instantclient_21_13" | pecl install oci8 && \
    docker-php-ext-enable oci8

# Ativar a extensão oci8 no php.ini
RUN echo "extension=oci8.so" > /usr/local/etc/php/conf.d/oci8.ini

# Copiar os arquivos da API
COPY public/ /var/www/html/

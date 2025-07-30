FROM php:8.2-apache

# Instala dependências necessárias
RUN apt-get update && apt-get install -y \
    unzip \
    libaio1 \
    wget \
    gnupg2 \
    libzip-dev \
    libssl-dev \
    && docker-php-ext-install mysqli

# Baixa e instala Oracle Instant Client
RUN mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    unzip instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.13.0.0.0dbru.zip && \
    echo /opt/oracle/instantclient_21_13 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

# Define variáveis de ambiente para o Oracle Instant Client
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_13
ENV ORACLE_HOME=/opt/oracle/instantclient_21_13

# Instala a extensão OCI8 (com entrada automática via here-doc)
RUN echo "instantclient,/opt/oracle/instantclient_21_13" | pecl install oci8-3.2.1 && \
    echo "extension=oci8.so" > /usr/local/etc/php/conf.d/oci8.ini

# Copia os arquivos da pasta pública para o Apache
COPY public/ /var/www/html/

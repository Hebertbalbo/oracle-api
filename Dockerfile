FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    unzip \
    libaio1 \
    wget \
    curl \
    gnupg2 \
    libzip-dev \
    && docker-php-ext-install mysqli

# Instala Oracle Instant Client via workaround com header de licença
RUN mkdir -p /opt/oracle && \
    cd /opt/oracle && \
    curl -L -o instantclient.zip \
    -H "Cookie: oraclelicense=accept-securebackup-cookie" \
    https://download.oracle.com/otn_software/linux/instantclient/2113000/instantclient-basiclite-linux.x64-21.13.0.0.0.zip && \
    unzip instantclient.zip && \
    rm instantclient.zip && \
    echo /opt/oracle/instantclient_21_13 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

# Variáveis de ambiente do Oracle
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_21_13
ENV ORACLE_HOME=/opt/oracle/instantclient_21_13

# Instala e ativa o oci8
RUN echo "instantclient,/opt/oracle/instantclient_21_13" | pecl install oci8 && \
    docker-php-ext-enable oci8

# Copia arquivos da pasta public
COPY public/ /var/www/html/

FROM php:8.2-apache

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    unzip \
    libaio1 \
    wget \
    gnupg2 \
    curl \
    libzip-dev \
    alien \
    && docker-php-ext-install mysqli

# Baixa e instala Oracle Instant Client via RPM (converter com alien)
RUN mkdir -p /opt/oracle && cd /opt/oracle && \
    wget https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient21/x86_64/getPackage/oracle-instantclient-basiclite-21.13.0.0.0-1.el8.x86_64.rpm && \
    wget https://yum.oracle.com/repo/OracleLinux/OL8/oracle/instantclient21/x86_64/getPackage/oracle-instantclient-sdk-21.13.0.0.0-1.el8.x86_64.rpm && \
    alien -i oracle-instantclient-basiclite-*.rpm && \
    alien -i oracle-instantclient-sdk-*.rpm

# Variáveis de ambiente Oracle
ENV LD_LIBRARY_PATH=/usr/lib/oracle/21/client64/lib
ENV ORACLE_HOME=/usr/lib/oracle/21/client64

# Instala oci8
RUN echo "instantclient,${ORACLE_HOME}" | pecl install oci8 && \
    docker-php-ext-enable oci8

# Copia os arquivos do projeto (assumindo que estão na pasta public/)
COPY public/ /var/www/html/

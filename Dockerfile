FROM php:8.2-apache

RUN apt-get update && apt-get install -y unzip libaio1 wget &&     docker-php-ext-install mysqli &&     pecl install oci8-3.2.1 &&     echo "extension=oci8.so" > /usr/local/etc/php/conf.d/oci8.ini

COPY public/ /var/www/html/

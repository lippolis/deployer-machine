FROM php:7.4-fpm
LABEL Mainteiner="Angelo Lippolis <info@angelolippolis.com>"

# apt-get required packages
RUN apt-get update -yqq && apt-get install -yqq git \ 
        openssh-client \ 
        libzip-dev \ 
        zip \ 
        unzip \ 
        iputils-ping \ 
        libicu-dev \ 
        libxml2-dev \
        jq \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmemcached-dev \
        libpng-dev \
        gnupg \
        build-essential \
        zlib1g-dev


# PHP extension installation
RUN docker-php-ext-install pdo_mysql zip bcmath json pcntl posix intl soap xml exif

# Install iconv and gd
RUN apt-get install -yqq libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Environmental variables
ENV COMPOSER_HOME /root/.composer
ENV COMPOSER_CACHE_DIR /cache
ENV PATH /root/.composer/vendor/bin:$PATH


# node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
      && apt-get install -y nodejs

# update npm to last version
# RUN npm i -g npm

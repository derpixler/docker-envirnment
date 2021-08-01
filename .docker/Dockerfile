FROM node:14.15.0-buster-slim

ENV OS_RELEASE buster
ENV XDEBUG_REMOTE_HOST 127.0.0.1

ARG DEBIAN_FRONTEND
ARG APP_ENV
ARG APP
ARG XDEBUG_CONFIG
ARG NODE_ENV
ARG PHP_VERSION
ARG USER=app
ARG USER_ID=1001
ARG USER_GID=1001

RUN echo "APP_ENV: $APP_ENV"
RUN echo "APP: $APP"
RUN echo "XDEBUG_CONFIG: $XDEBUG_CONFIG"
RUN echo "NODE_ENV: $NODE_ENV"
RUN echo "PHP_VERSION: $PHP_VERSION"
RUN echo "USER: $USER | USER_ID: $USER_ID | USER_GID: $USER_GID"

# Setup Basics
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update && apt-get install -y --no-install-recommends apt-utils apt-transport-https gnupg2 ca-certificates libssl-dev libmcrypt-dev wget curl locales \
    && rm -rf /var/lib/apt/lists/*

RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8
#ENV USER=APP USER_ID=1000 USER_GID=1000

# Install basic stuff
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ ${OS_RELEASE} main" | tee /etc/apt/sources.list.d/php.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        netcat \
        software-properties-common \
        sudo \
        vim \
        git \
        htop \
        php-pear \
        php${PHP_VERSION}-dev \
        php${PHP_VERSION} \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-memcached \
        php${PHP_VERSION}-imagick \
        gettext \
	&& rm -rf /var/lib/apt/lists/*

# Install XDEBUG
RUN pecl channel-update pecl.php.net
RUN pecl install xdebug

# Permissions
# now creating group and add user and add to sudo
RUN groupadd -o --gid "${USER_GID}" "${USER}" > /dev/null 2>&1 || echo "Group already exists." \
    && useradd -l \
      --uid ${USER_ID} \
      --gid ${USER_GID} \
      --create-home \
      --shell /bin/bash \
      ${USER} > /dev/null 2>&1  || echo "User already exists." \
    && usermod -aG root,sudo,node $(id -un $USER_ID) \
    && sed -i -e 's/%sudo\s*ALL=(ALL:ALL) ALL/%sudo ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers \
    && visudo -cf /etc/sudoers

# Copy Data
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Additional config
WORKDIR /var/www/app

# Create Folders
RUN mkdir -p /var/www/app/log \
    && mkdir /run/php \
    && mkdir -p /var/lib/php/session \
    && chmod -R 777 /var/lib/php/session \
    && mkdir -p /etc/php/${PHP_VERSION}/custom \
    && rm /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
    && cp -r /etc/php/${PHP_VERSION} /etc/php/current_xdebug

# Create Symlinks
RUN echo "alias ll='ls --color --group-directories-first -slah'" >> ~/.bashrc \
    && ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm \
    && ln -s /etc/init.d/php${PHP_VERSION}-fpm /etc/init.d/php-fpm \
    && ln -s /etc/php/${PHP_VERSION} /etc/php/current

# Copy only default configs
COPY php/conf.d/90-xdebug-defaults.ini /etc/php/current/custom/
RUN ln -sf /etc/php/current/custom/90-xdebug-defaults.ini /etc/php/current/cli/conf.d/90-xdebug-defaults.ini \
    && ln -sf /etc/php/current/custom/90-xdebug-defaults.ini /etc/php/current/fpm/conf.d/90-xdebug-defaults.ini

COPY php/conf.d/99-cli.ini /etc/php/current/cli/conf.d/
COPY php/conf.d/99-fpm.ini /etc/php/current/fpm/conf.d/


COPY php/pool.d/app.conf /etc/php/current/fpm/pool.d/app.conf
COPY php/pool.d/app-xdebug.conf /etc/php/current_xdebug/fpm/pool.d/app-xdebug.conf
COPY php/php-fpm.conf /etc/php/current/fpm/php-fpm.conf
COPY php/php-fpm-xdebug.conf /etc/php/current_xdebug/fpm/php-fpm.conf
COPY php/init.d/php-fpm-xdebug /etc/init.d/php-fpm-xdebug

# Starting default php-fpm
COPY shell/start-php-fpm.sh /usr/bin/start-php-fpm.sh
RUN chmod +x /usr/bin/start-php-fpm.sh

RUN /usr/bin/start-php-fpm.sh

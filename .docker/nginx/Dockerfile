FROM nginx:latest

ARG USER_ID=1000
ARG USER_GID=1000
ARG HOST=foo.de

RUN mkdir -p /var/www/app
RUN mkdir -p /tmp
RUN mkdir -p /etc/nginx/sites-available
RUN mkdir -p /etc/nginx/sites-enabled

# Fix Docker usermod and groupmod unlimited filesize bug
RUN ln -sfn /dev/null /var/log/lastlog
RUN ln -sfn /dev/null /var/log/faillog

# Add www-data to root users group for access problems - Maybe problems on linux
RUN usermod -aG root www-data \
    && usermod -u ${USER_ID} www-data \
    && groupmod -o -g ${USER_GID} www-data

RUN echo "alias ll='ls --color --group-directories-first -slah'" >> ~/.bashrc

# Copy configs
COPY conf.d/* /etc/nginx/conf.d/
COPY ssl/* /etc/nginx/ssl/
COPY nginx.conf /etc/nginx/nginx.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf

COPY shell/generate-site-conf.sh /usr/bin/generate-site-conf.sh
COPY shell/site-conf.stub /usr/bin/site-conf.stub
RUN chmod +x /usr/bin/generate-site-conf.sh

RUN /usr/bin/generate-site-conf.sh ${HOST}

# Symplink available sites
RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade && apt-get install --no-install-recommends -y \
    build-essential \
    gdb \
    cmake \
    git \
    tree \
    htop \
    tmux \
    vim \
    libicu-dev \
    libboost1.71-all-dev \
    curl \
    postgresql \
    nginx-full && rm -rf /var/lib/apt/lists/*;

RUN mkdir /forum && mkdir /forum/repos

RUN cd /forum/repos/ && git clone https://github.com/danij/Forum.git
RUN cd /forum/repos/Forum/ && git checkout master
RUN mkdir /forum/repos/Forum-RelWithDebInfo
RUN cd /forum/repos/Forum-RelWithDebInfo/ && cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo /forum/repos/Forum/ && make

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g webpack webpack-cli && npm cache clean --force;

RUN cd /forum/repos/ && git clone https://github.com/danij/Forum.Auth.git
RUN curl -f https://danistorage.blob.core.windows.net/public/password.js -o /forum/repos/Forum.Auth/services/password.js
RUN cd /forum/repos/Forum.Auth/ && npm install && npm cache clean --force;

RUN cd /forum/repos/ && git clone https://github.com/danij/Forum.Attachments.git
RUN cd /forum/repos/Forum.Attachments/ && npm install && npm cache clean --force;

RUN cd /forum/repos/ && git clone https://github.com/danij/Forum.Search.git
RUN cd /forum/repos/Forum.Search/ && npm install && npm cache clean --force;

RUN cd /forum/repos/ && git clone https://github.com/danij/Forum.WebClient.git
RUN cd /forum/repos/Forum.WebClient/ && npm install && npm cache clean --force;
RUN cd /forum/repos/Forum.WebClient/ && webpack --config webpack.production.js
RUN rm /var/www/html/*
RUN cp -a /forum/repos/Forum.WebClient/dist/. /var/www/html/
RUN mv /var/www /var/www-old

RUN rm /etc/nginx/modules-enabled/50-mod-http-auth-pam.conf \
 && rm /etc/nginx/modules-enabled/50-mod-http-dav-ext.conf \
 && rm /etc/nginx/modules-enabled/50-mod-http-echo.conf \
 && rm /etc/nginx/modules-enabled/50-mod-http-geoip.conf \
 && rm /etc/nginx/modules-enabled/50-mod-http-image-filter.conf \
 && rm /etc/nginx/modules-enabled/50-mod-http-subs-filter.conf \
 && rm /etc/nginx/modules-enabled/50-mod-http-upstream-fair.conf \
 && rm /etc/nginx/modules-enabled/50-mod-http-xslt-filter.conf \
 && rm /etc/nginx/modules-enabled/50-mod-mail.conf \
 && rm /etc/nginx/modules-enabled/50-mod-stream.conf

RUN cp /forum/repos/Forum.WebClient/docker/nginx.config /etc/nginx/sites-available/default
RUN sed -i 's# TLSv1 TLSv1.1##' /etc/nginx/nginx.conf
RUN sed -i 's#gzip on;#gzip off;#' /etc/nginx/nginx.conf

RUN rm -r /var/log/nginx
RUN ln -s /forum/logs/nginx /var/log/nginx

RUN chmod +x /forum/repos/Forum/docker/bootstrap-global.sh
CMD ["/bin/bash", "/forum/start/start.sh"]

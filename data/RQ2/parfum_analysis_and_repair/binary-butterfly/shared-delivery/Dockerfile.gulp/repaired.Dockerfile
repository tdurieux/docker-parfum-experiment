FROM node:12
LABEL maintainer "Ernesto Ruge <mail@ernestoruge.de>"
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV LANGUAGE en_US.utf8

RUN apt-get update && \
    apt-get install --no-install-recommends -y locales apt-utils && \
    locale-gen en_US en_US.UTF-8 && \
    echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale && \
    apt-get dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN groupadd -g 1002 webdev
RUN useradd -u 1002 -g webdev -m -d /home/webdev -s /bin/bash webdev

ENV HOME /home/webdev

RUN mkdir /app && chown webdev:webdev /app
WORKDIR /app
COPY --chown=webdev:webdev . /app

RUN ln -s /app/node_modules/gulp/bin/gulp.js /usr/bin/gulp

USER webdev
RUN npm install && npm cache clean --force;
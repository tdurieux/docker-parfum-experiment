FROM ymedlop/npm-cache-resource:latest

ENV VERSION 0.6.0-1
RUN apk --update add \
   bash \
   curl \
   g++ \
   make \
   openssh \
   openssl \
   openssl-dev \
   && rm -rf /var/cache/apk/*
RUN curl -f -L https://github.com/AGWA/git-crypt/archive/debian/$VERSION.tar.gz | tar zxv -C /var/tmp
RUN cd /var/tmp/git-crypt-debian-$VERSION && make && make install PREFIX=/usr/local && rm -rf /var/tmp/*
RUN apk del make openssl-dev

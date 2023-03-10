FROM ubuntu:bionic

RUN apt-get update \
  && apt-get install --no-install-recommends -y mysql-client openssh-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash --uid 1001 util

USER util
WORKDIR /home/util
RUN mkdir .ssh && chmod 0700 .ssh

RUN echo '#!/bin/sh\nmysql --host=db -uroot -p<%= @db_password %> course_management' > mysql && chmod 0755 mysql
RUN echo '#!/bin/sh\nssh -4 -o "StrictHostKeyChecking=no" -N -L 0.0.0.0:3333:onara5.local:3308 -p24 ggbaker@coursys.sfu.ca' > ssh-forward && chmod 0755 ssh-forward

EXPOSE 3333

CMD ./ssh-forward
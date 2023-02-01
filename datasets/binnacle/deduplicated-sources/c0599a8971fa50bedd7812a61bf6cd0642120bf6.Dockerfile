FROM instructure/node:8-xenial
MAINTAINER Instructure

USER root

# Install Nginx
RUN  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y apt-transport-https ca-certificates \
  # TODO can this be a non-passenger source? don't think we can take it out
  # because then we get nginx 1.10 instead of 1.14, and I'm not sure if 1.10
  # has the features we need
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nginx-extras \
    ruby \
    sudo \
    supervisor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN yarn global add pm2@3.1.2

RUN mkdir -p /usr/src/supervisord/ \
 && mkdir -p /usr/src/nginx/conf.d \
 && mkdir -p /usr/src/nginx/location.d \
 && mkdir -p /usr/src/app \
 && mkdir -p /var/log/app \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && ln -sf /dev/stdout /var/log/app/output.log \
 && ln -sf /dev/stderr /var/log/app/error.log

COPY entrypoint /usr/src/entrypoint
COPY supervisord/* /usr/src/supervisord/
COPY nginx.conf.erb /usr/src/nginx/nginx.conf.erb
COPY conf.d/* /usr/src/nginx/conf.d/
COPY default.config.json /usr/src/app/.pm2.config.default.json

RUN chown docker:docker -R /usr/src/supervisord \
 && chown docker:docker -R /usr/src/nginx \
 && chown docker:docker -R /var/lib/nginx \
 && chown docker:docker -R /var/log/app \
 && chgrp docker /var/run \
 && chmod g+w /var/run

USER docker

EXPOSE 80

ENTRYPOINT ["/tini", "--"]

CMD ["/usr/src/entrypoint"]

# ubuntu -- https://hub.docker.com/_/ubuntu/
# |==> phusion/baseimage -- https://github.com/phusion/baseimage-docker
#      |==> phusion/passenger-docker -- https://github.com/phusion/passenger-docker
#           |==> HERE
FROM phusion/passenger-ruby27:2.0.1

# Update OS as per https://github.com/phusion/passenger-docker#upgrading-the-operating-system-inside-the-container
# Broken update https://github.com/DiUS/pact_broker-docker/runs/3799650621?check_suite_focus=true#step:9:87
# RUN apt-get update && \
#    apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
#    apt-get -qy autoremove && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN bash -lc 'rvm --default use ruby-2.7.4'

ENV APP_HOME=/home/app/pact_broker/
WORKDIR $APP_HOME

RUN rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default
COPY container /
#USER app
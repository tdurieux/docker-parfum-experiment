FROM debian:buster
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update --allow-releaseinfo-change
RUN apt-get -y --no-install-recommends install wget curl vim git supervisor postgresql-client default-jre gnupg2 locales libssl-dev libxss-dev pdftk bzip2 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Add Supervisor config and run the deamon
ADD conf/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

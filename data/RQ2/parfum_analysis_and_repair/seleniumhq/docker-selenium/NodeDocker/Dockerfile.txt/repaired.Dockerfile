USER root

#==============
# Socat to proxy docker.sock when mounted
#==============
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install socat \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

USER 1200

#========================
# Selenium Standalone Docker Configuration
#========================

EXPOSE 4444

COPY start-selenium-grid-docker.sh \
    config.toml \
    start-socat.sh \
    /opt/bin/

COPY selenium-grid-docker.conf /etc/supervisor/conf.d/


FROM harbor-repo.vmware.com/dockerhub-proxy-cache/library/golang:latest
MAINTAINER PCF Security Enablement <pcf-security-enablement@pivotal.io>

ENV TERM dumb
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /

# Install Common Dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y unzip && \
    apt-get upgrade -y -qq && \
    apt-get -y clean && \
    apt-get -y autoremove --purge && rm -rf /var/lib/apt/lists/*;
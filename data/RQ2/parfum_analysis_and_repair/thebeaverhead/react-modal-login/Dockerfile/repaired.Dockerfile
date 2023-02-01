FROM ubuntu:18.04
MAINTAINER support@thebeaverhead.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get -yq --no-install-recommends install curl gnupg \
#  nodejs, npm and tools
  && apt-get install --no-install-recommends curl nodejs npm -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN nvm install 16.13.1
VOLUME [ "/var/www"]

WORKDIR /var/www

EXPOSE  8080

CMD bash

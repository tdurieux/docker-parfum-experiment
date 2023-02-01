FROM        ubuntu
MAINTAINER  Matthew Fisher <me@bacongobbler.com>

RUN apt-get update && apt-get install --no-install-recommends -yq pound && rm -rf /var/lib/apt/lists/*;

EXPOSE  80

ADD pound.cfg /etc/pound/pound.cfg

CMD pound

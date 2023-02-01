FROM        ubuntu
MAINTAINER  Matthew Fisher <me@bacongobbler.com>

RUN apt-get update && apt-get install --no-install-recommends -yq apache2 && rm -rf /var/lib/apt/lists/*;

EXPOSE  80

ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND

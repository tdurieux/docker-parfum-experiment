FROM ubuntu:precise
MAINTAINER Peter Morgan <peter.james.morgan@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y \
    wget && rm -rf /var/lib/apt/lists/*;

RUN wget --no-check-certificate https://packagecloud.io/install/repositories/shortishly/lighthouse/script.deb.sh
RUN chmod u+x script.deb.sh
RUN ./script.deb.sh

RUN apt-get update && apt-get install --no-install-recommends -y \
    lighthouse && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT /opt/lighthouse/bin/lighthouse console
EXPOSE 8181

FROM biopython/biopython-sql:latest
MAINTAINER Tiago Antao <tra@popgen.net>

ENV DEBIAN_FRONTEND noninteractive

#BuildBot
RUN apt-get update && apt-get install --no-install-recommends -y buildbot-slave git && rm -rf /var/lib/apt/lists/*;

RUN buildslave create-slave biopython testing.open-bio.org:9989 CHANGEUSER CHANGEPASS

RUN echo "buildslave start biopython" >> entrypoint.sh
RUN echo "tail -f biopython/twistd.log" >> entrypoint.sh

ENTRYPOINT bash entrypoint.sh

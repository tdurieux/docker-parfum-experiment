FROM ubuntu:17.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN set -e -x ;\
        groupadd -g 1337 chall ;\
        useradd -g 1337 -u 1337 -m chall

COPY challenge/flag.txt /home/chall
COPY challenge/compile.sh /home/chall

RUN set -e -x ;\
        chown -R chall:chall /home/chall ;\
        chmod -R 755 /home/chall ;\
        chmod 0000 /home/chall/flag.txt

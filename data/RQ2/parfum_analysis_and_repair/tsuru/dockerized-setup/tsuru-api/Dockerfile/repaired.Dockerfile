FROM ubuntu:14.04

MAINTAINER tsuru <tsuru@corp.globo.com>
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B0DE9C5DEBF486359EB255B03B0153D0383F073D
RUN echo "deb http://ppa.launchpad.net/tsuru/ppa/ubuntu trusty main"  > /etc/apt/sources.list.d/tsuru.list
RUN apt-get update && apt-get install --no-install-recommends -y tsuru-server patch && rm -rf /var/lib/apt/lists/*;

EXPOSE      8000

COPY ./tsuru-defaults /etc/default/tsuru-server

LABEL name="tsuru-api"

ENTRYPOINT ["/usr/bin/tsurud"]

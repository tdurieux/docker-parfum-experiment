FROM ubuntu:16.04
RUN apt-get -yq update
RUN apt-get install -yq dnsutils curl netcat

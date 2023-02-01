FROM ubuntu:14.04
MAINTAINER FIWARE Adminotech
COPY realxtend-tundra-2.5.4-ubuntu-14.04-amd64.deb /tundra.deb
RUN apt-get update && apt-get -f install -y
RUN dpkg -i /tundra.deb; exit 0

RUN rm /tundra.deb
EXPOSE 2345
EXPOSE 2346

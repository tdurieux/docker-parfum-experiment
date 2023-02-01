FROM ubuntu
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq --no-install-recommends install git gcc make && rm -rf /var/lib/apt/lists/*;

FROM ubuntu

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install --no-install-recommends -y git subversion build-essential && rm -rf /var/lib/apt/lists/*;

RUN git config --global user.email "m.maatkamp@gmail.com"
RUN git config --global user.name "Marcel Maatkamp"

VOLUME /projects

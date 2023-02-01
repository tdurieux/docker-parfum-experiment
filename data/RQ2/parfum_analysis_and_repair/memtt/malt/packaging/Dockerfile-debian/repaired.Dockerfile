#distri we want
FROM debian:jessie

#workdir
WORKDIR /workdir
ENV IN_DOCKER yes

#get list of packages
RUN apt-get update

#install deps
RUN apt-get install --no-install-recommends -y build-essential make gcc cmake g++ git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libunwind-dev libelf-dev libqt5webkit5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pbuilder debootstrap devscripts cdbs debhelper && rm -rf /var/lib/apt/lists/*;


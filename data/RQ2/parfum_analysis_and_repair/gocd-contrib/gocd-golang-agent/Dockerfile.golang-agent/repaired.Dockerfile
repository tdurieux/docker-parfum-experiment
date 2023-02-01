FROM ubuntu:trusty
MAINTAINER GoCD Team <go-cd@googlegroups.com>

# install gocd-golang-agent
RUN echo deb https://dl.bintray.com/alex-hal9000/gocd-golang-agent master main | tee -a /etc/apt/sources.list
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update
RUN apt-get -y --no-install-recommends --force-yes install gocd-golang-agent && rm -rf /var/lib/apt/lists/*;

# add ubuntu-lxc apt-get repo (for newer version of golang)
RUN apt-get -y --no-install-recommends install software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-lxc/lxd-stable
RUN apt-get -y update

# install project specific packages
RUN apt-get -y --no-install-recommends install golang git && rm -rf /var/lib/apt/lists/*;

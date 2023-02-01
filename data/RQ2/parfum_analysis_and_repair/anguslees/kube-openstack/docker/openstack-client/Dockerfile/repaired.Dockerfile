FROM ubuntu:vivid
MAINTAINER Angus Lees <gus@inodes.org>

RUN adduser --disabled-login --gecos 'Generic unprivileged user' user

RUN apt-get -qq update && apt-get -qqy --no-install-recommends install python-openstackclient python-keystoneclient python-novaclient python-swiftclient python-glanceclient python-neutronclient python-ceilometerclient python-cinderclient python-heatclient python-troveclient && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qqy upgrade



ADD openrc /home/user/openrc
ADD bashrc /home/user/.bashrc

USER user
WORKDIR /home/user
CMD ["/bin/bash"]

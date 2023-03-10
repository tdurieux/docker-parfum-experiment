FROM ubuntu:trusty

LABEL description="Ubuntu Trusty ICL Build Environment"

RUN apt-get update
# pcl has to be install from a PPA
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:v-launchpad-jochen-sprickerhof-de/pcl
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y build-essential git cmake python-pip dirmngr \
                       devscripts equivs apt-file debhelper sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN useradd --create-home -s /bin/bash user
RUN echo user:user | chpasswd
RUN adduser user sudo
RUN echo "user ALL=(ALL:ALL) NOPASSWD: /usr/bin/mk-build-deps" >> /etc/sudoers

WORKDIR /home/user
USER user
CMD ["workspace/icl/packaging/scripts/build-ubuntu-packages.sh"]

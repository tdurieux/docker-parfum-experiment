# w3af.org
# https://github.com/andresriancho/w3af/tree/master/extras

FROM ubuntu:12.04
MAINTAINER Andres Riancho <andres.riancho@gmail.com>

# Initial setup
RUN mkdir /home/w3af
WORKDIR /home/w3af
ENV HOME /home/w3af
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LOGNAME w3af
# Squash errors about "Falling back to ..." during package installation
ENV TERM linux
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update before installing any package
RUN apt-get update -y && apt-get install --no-install-recommends -y python-pip build-essential libxslt1-dev libxml2-dev libsqlite3-dev libyaml-dev openssh-server python-dev git python-lxml wget libssl-dev xdot python-gtk2 python-gtksourceview2 ubuntu-artwork dmz-cursor-theme ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

# Install basic and GUI requirements, python-lxml because it doesn't compile correctly from pip


# Add the w3af user
# TODO - actually use the w3af user instead of running everything as root
RUN useradd w3af

# Get ssh package ready
RUN mkdir /var/run/sshd
RUN echo 'root:w3af' | chpasswd
RUN mkdir /home/w3af/.ssh/
RUN echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjXxcHjyVkwHT+dSYwS3vxhQxZAit6uZAFhuzA/dQ2vFu6jmPk1ewMGIYVO5D7xV3fo7/RXeCARzqHl6drw18gaxDoBG3ERI6LxVspIQYjDt5Vsqd1Lv++Jzyp/wkXDdAdioLTJyOerw7SOmznxqDj1QMPCQni4yhrE+pYH4XKxNx5SwxZTPgQWnQS7dasY23bv55OPgztI6KJzZidMEzzJVKBXHy1Ru/jjhmWBghiXYU5RBDLDYyT8gAoWedYgzVDmMZelLR6Y6ggNLOtMGiGYfPWDUz9Z6iDAUsOQBtCJy8Sj8RwSQNpmOgSzBanqnhed14hLwdYhnKWcPNMry71 w3af@w3af-docker.org' > /home/w3af/.ssh/w3af-docker.pub
RUN mkdir -p /root/.ssh/
RUN cat /home/w3af/.ssh/w3af-docker.pub >> /root/.ssh/authorized_keys

# Get and install pip
RUN pip install --no-cache-dir --upgrade pip

# We install some pip packages before adding the code in order to better leverage
# the docker cache
RUN pip install --no-cache-dir clamd==1.0.1 PyGithub==1.21.0 GitPython==0.3.2.RC1 pybloomfiltermmap==0.3.11 \
        esmre==0.3.1 phply==0.9.1 stopit==1.1.0 nltk==2.0.5 chardet==2.1.1 pdfminer==20140328 \
        futures==2.1.5 pyOpenSSL==0.13.1 scapy-real==2.2.0-dev guess-language==0.2 cluster==1.1.1b3 \
        msgpack-python==0.4.4 python-ntlm==1.0.1 halberd==0.2.4 darts.util.lru==0.5 \
        tblib==0.2.0 ndg-httpsclient==0.3.3 pyasn1==0.1.7

# Install w3af
ADD . /home/w3af/w3af
WORKDIR /home/w3af/w3af
RUN ./w3af_console ; true

# Change the install script to add the -y and not require input
RUN sed 's/sudo //g' -i /tmp/w3af_dependency_install.sh
RUN sed 's/apt-get/apt-get -y/g' -i /tmp/w3af_dependency_install.sh
RUN sed 's/pip install/pip install --upgrade/g' -i /tmp/w3af_dependency_install.sh

# Run the dependency installer
RUN /tmp/w3af_dependency_install.sh

# Run the dependency installer
RUN ./w3af_gui ; true
RUN sed 's/sudo //g' -i /tmp/w3af_dependency_install.sh
RUN sed 's/apt-get/apt-get -y/g' -i /tmp/w3af_dependency_install.sh
RUN sed 's/pip install/pip install --upgrade/g' -i /tmp/w3af_dependency_install.sh
RUN /tmp/w3af_dependency_install.sh

# Compile the py files into pyc in order to speed-up w3af's start
RUN python -m compileall -q .

# Cleanup to make the image smaller
RUN rm /tmp/w3af_dependency_install.sh
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/pip-build-root

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

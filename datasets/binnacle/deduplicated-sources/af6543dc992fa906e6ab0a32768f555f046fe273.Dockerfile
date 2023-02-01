FROM solita/ubuntu-systemd
LABEL description="Labtainer base image from ubuntu-systemd"
ARG lab
RUN mv /etc/apt/sources.list /var/tmp/
ADD system/etc/nps.sources.list /etc/apt/sources.list
ADD system/bin/apt-source.sh /usr/bin/apt-source.sh
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    expect \
    file \
    gcc-multilib \
    gdb \
    iputils-ping \
    less \
    man \
    manpages-dev \
    net-tools \
    openssh-client \
    python \
    sudo \
    tcl8.6 \
    vim \
    zip \
    hexedit \
    rsyslog \
    ghex \
    leafpad \
    locales \
    nano \
    python-pip

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
RUN sudo pip install --upgrade pip
RUN sudo pip install setuptools
RUN sudo pip install parse
RUN pip install inotify_simple
RUN pip install enum
ADD system/etc/sudoers /etc/sudoers
ADD system/etc/rc.local /etc/rc.local
ADD system/bin/funbuffer /usr/bin/
# manage default gateways
ADD system/bin/togglegw.sh /usr/bin/
ADD system/bin/set_default_gw.sh /usr/bin/
ADD system/sbin/waitparam.sh /sbin/waitparam.sh
ADD system/lib/systemd/system/waitparam.service /lib/systemd/system/waitparam.service
RUN systemctl enable waitparam.service

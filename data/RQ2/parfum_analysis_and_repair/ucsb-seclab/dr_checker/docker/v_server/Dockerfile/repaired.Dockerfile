FROM ubuntu

RUN apt-get -y update

RUN apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install sl htop psmisc psutils time iotop iputils-ping net-tools build-essential ssh sshfs bash-completion rsync \
                       git screen stress tmux iperf libxml2-dev openjdk-8-jdk ipython pypy python-dev python-pip virtualenvwrapper \
                       libxml2-dev pkg-config curl cmake sudo vim bc && rm -rf /var/lib/apt/lists/*;

ADD install.sh /tmp/install.sh
RUN chmod a+rx /tmp/install.sh
RUN /tmp/install.sh

CMD ["tail", "-f", "/dev/null" ]


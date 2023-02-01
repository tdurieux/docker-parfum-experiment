ARG UBUNTU_VERSION=16.04
FROM ubuntu:${UBUNTU_VERSION}

ARG FPM_VERSION=1.11.0
ARG PYTHON_VERSION=3
ARG DOCKER_WORKDIR=/usr/share/pdagent-integrations
ENV PYTHON_VERSION ${PYTHON_VERSION}
ENV container docker
ENV DEBIAN_FRONTEND noninteractive
ENV DOCKER_WORKDIR ${DOCKER_WORKDIR}

RUN apt-get update -y -qq
RUN apt-get install --no-install-recommends -y -q apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q ruby2.3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q ruby2.3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q systemd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q bsdmainutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-ca-certificates

RUN gem install -q --no-ri --no-rdoc -v ${FPM_VERSION} fpm
RUN apt-get install --no-install-recommends -y -q python${PYTHON_VERSION} && rm -rf /var/lib/apt/lists/*;
RUN cd /lib/systemd/system/sysinit.target.wants/ \
    && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1

RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*

VOLUME [ "/sys/fs/cgroup" ]

COPY . $DOCKER_WORKDIR
WORKDIR $DOCKER_WORKDIR

CMD ["/lib/systemd/systemd"]

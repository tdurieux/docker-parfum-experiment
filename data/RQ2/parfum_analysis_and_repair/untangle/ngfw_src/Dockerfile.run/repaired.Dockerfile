FROM docker.untangle.int/ngfw:base
LABEL maintainer="Sebastien Delafond <sdelafond@gmail.com>"

ENV SRC=/opt/untangle/ngfw_src
RUN mkdir -p ${SRC}
VOLUME ${SRC}

WORKDIR ${SRC}

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes untangle-development-runtime && rm -rf /var/lib/apt/lists/*;
RUN systemctl start postgresql

EXPOSE 80

ENTRYPOINT ./dist/etc/init.d/untangle-vm start

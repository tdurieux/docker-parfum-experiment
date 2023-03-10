FROM debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN echo "deb http://deb.debian.org/debian stretch main contrib\n \
deb http://deb.debian.org/debian-security stretch/updates main" > /etc/apt/sources.list && apt-get update && apt-get -y --force-yes dist-upgrade

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y --force-yes lsb-release wget default-jre sudo vim openssh-server curl netcat build-essential && rm -rf /var/lib/apt/lists/*;

COPY scripts/install_mysql.sh /scripts/
RUN GOPATH=$HOME/gopath PATH=$HOME/gopath/bin:$PATH DOCKER_BUILD=1 /bin/sh scripts/install_mysql.sh
COPY scripts/install_go.sh /scripts/
RUN GOPATH=$HOME/gopath PATH=$HOME/gopath/bin:$PATH DOCKER_BUILD=1 /bin/sh scripts/install_go.sh
COPY scripts/start_kafka.sh /scripts/
COPY scripts/install_kafka.sh /scripts/
RUN GOPATH=$HOME/gopath PATH=$HOME/gopath/bin:$PATH DOCKER_BUILD=1 /bin/sh scripts/install_kafka.sh
COPY scripts/install_hadoop.sh /scripts/
RUN GOPATH=$HOME/gopath PATH=$HOME/gopath/bin:$PATH DOCKER_BUILD=1 /bin/sh scripts/install_hadoop.sh
COPY scripts/install_sql.sh /scripts/
RUN GOPATH=$HOME/gopath PATH=$HOME/gopath/bin:$PATH DOCKER_BUILD=1 /bin/sh scripts/install_sql.sh
COPY scripts/install_hive.sh /scripts/
RUN GOPATH=$HOME/gopath PATH=$HOME/gopath/bin:$PATH DOCKER_BUILD=1 /bin/sh scripts/install_hive.sh

COPY scripts/prepare_test_env.sh /scripts/

COPY scripts/docker_test_entry.sh /
RUN chmod +x /docker_test_entry.sh

RUN echo 'set -x;sh scripts/prepare_test_env.sh\nexport GOPATH=~/gopath;export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"\nexport STORAGETAPPER_ENVIRONMENT=test' >/root/.bashrc

WORKDIR /storagetapper

ENV USER=root
RUN echo "export PATH=$PATH:/root/gopath/bin:/usr/local/go/bin" > /root/.bashrc

CMD /bin/bash -l

FROM golang:1.16.6-stretch
LABEL maintainer="openark@github.com"

RUN apt-get update && apt-get install --no-install-recommends -y lsb-release rsync libaio1 numactl sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

ENV WORKPATH /go/src/github.com/openark/orchestrator
WORKDIR $WORKPATH

RUN curl -f -O "https://raw.githubusercontent.com/openark/orchestrator-ci-env/master/bin/linux/dbdeployer.gz"
RUN curl -f -O "https://raw.githubusercontent.com/openark/orchestrator-ci-env/master/mysql-tarballs/mysql-5.7.26.tar.xz"
RUN gunzip ./dbdeployer.gz
RUN chmod +x ./dbdeployer
RUN mkdir -p ./sandbox/binary

RUN ./dbdeployer unpack mysql-5.7.26.tar.xz --sandbox-binary $WORKPATH/sandbox/binary

COPY . .

CMD ["script/test-all"]

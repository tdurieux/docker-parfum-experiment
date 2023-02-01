FROM golang:1.18-buster

ENV DEBIAN_FRONTEND=noninteractive

# Get sysbench installed
RUN apt update
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | bash
RUN apt -y --no-install-recommends install sysbench && rm -rf /var/lib/apt/lists/*;

# Install sqlite3 from source
RUN \
  apt-get install --no-install-recommends -y \
  build-essential \
  tcl \
  lsb-release \
  && wget \
    -O sqlite.tar.gz \
    https://www.sqlite.org/src/tarball/sqlite.tar.gz?r=release \
  && tar xvfz sqlite.tar.gz \
  # Configure and make SQLite3 binary
  && ./sqlite/configure --prefix=/usr \
  && make \
  && make install \
  # Smoke test
  && sqlite3 --version && rm sqlite.tar.gz && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY ./go /dolt/go
COPY ./config.json /config.json
COPY ./tpcc-config.json /tpcc-config.json
COPY ./sysbench-runner-tests-entrypoint.sh /entrypoint.sh
RUN git clone https://github.com/dolthub/sysbench-lua-scripts.git
RUN git clone https://github.com/Percona-Lab/sysbench-tpcc.git

WORKDIR /mysql
RUN curl -f -L -O https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
RUN dpkg -i mysql-apt-config_0.8.22-1_all.deb
RUN apt-get update && apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
RUN mysql --version

# Install dolt
WORKDIR /dolt/go/cmd/dolt
RUN go build -o /usr/local/bin/dolt .

WORKDIR /dolt/go/performance/utils/sysbench_runner/cmd
ENTRYPOINT ["/entrypoint.sh"]

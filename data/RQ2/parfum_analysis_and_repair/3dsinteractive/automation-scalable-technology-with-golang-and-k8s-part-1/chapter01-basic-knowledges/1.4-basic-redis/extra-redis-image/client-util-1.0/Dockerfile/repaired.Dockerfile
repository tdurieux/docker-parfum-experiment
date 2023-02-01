FROM ubuntu:16.04

MAINTAINER 3DS Interactive (contact@3dsinteractive.com)

ENV HOME /root

# install
# - redis-cli
# - net tools
# - mysql client
# - python3
# - aws-cli
# - telnet
# - git
# - wrk2
# - golang

# install requirements
RUN apt-get update
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# install python3.6
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get -y --no-install-recommends --fix-missing install python3.6 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1 && rm -rf /var/lib/apt/lists/*;

# install prerequisite
RUN apt-get update
RUN apt-get -y --no-install-recommends install traceroute && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install dnsutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install netcat-openbsd && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install nmap && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install redis-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install mysql-client-5.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install sqlite3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bzip2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libbz2-dev && rm -rf /var/lib/apt/lists/*;

# install kafkacat
RUN apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install kafkacat && rm -rf /var/lib/apt/lists/*;

# install pip
RUN curl -f -sS https://bootstrap.pypa.io/get-pip.py | python3
# install aws-cli (required python3 & pip installed above)
RUN pip3 install --no-cache-dir awscli --upgrade --user
# PATH for python
ENV PATH="/root/.local/bin:${PATH}"

# install wrk2
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/giltene/wrk2.git /home/root/wrk2 &&\
    cd /home/root/wrk2 &&\
    make &&\
    cp wrk /usr/local/bin &&\
    rm -Rf /home/root/wrk2

# Install Lua and Luarocks - a lua package manager
RUN apt-get -y --no-install-recommends install lua5.1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install liblua5.1-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /home/root && \
    curl -f https://keplerproject.github.io/luarocks/releases/luarocks-2.2.2.tar.gz -L --output luarocks-2.2.2.tar.gz && \
    tar -xzvf luarocks-2.2.2.tar.gz && \
    cd luarocks-2.2.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make build && \
    make install && \
    rm -Rf /home/root/luarocks-2.2.2 && \
    rm /home/root/luarocks-2.2.2.tar.gz

# Install the cjson package (unzip is needed for luarocks)
RUN apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;
RUN cd /home/root &&\
    luarocks install lua-cjson
# Raise the limits for wrk to open many file while load testing
RUN ulimit -c -m -s -t unlimited

# Install go 1.14.4
RUN curl -f https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz -L --output go1.14.4.linux-amd64.tar.gz
RUN tar -xvzf go1.14.4.linux-amd64.tar.gz && rm go1.14.4.linux-amd64.tar.gz
RUN rm go1.14.4.linux-amd64.tar.gz
ENV PATH="/go/bin:${PATH}"

# add user 1001
RUN useradd -u 1001 --no-create-home 1001
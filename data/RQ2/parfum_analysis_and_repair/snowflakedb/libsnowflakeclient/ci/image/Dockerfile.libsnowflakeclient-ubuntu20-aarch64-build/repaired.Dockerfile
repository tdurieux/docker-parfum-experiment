FROM arm64v8/ubuntu:focal

ENV DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC"

RUN apt-get update

# dev toolsets
RUN apt-get install --no-install-recommends -y git cmake g++ zip python3.8 libre2-dev unixodbc-dev unixodbc libcppunit-dev vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y gosu \
    && ln -s /usr/sbin/gosu /usr/local/bin/gosu && rm -rf /var/lib/apt/lists/*;
# Java
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y --fix-missing python3-pip valgrind \
    && ln -s /usr/bin/python3 /usr/local/bin/python && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir awscli

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# workspace

RUN mkdir -p /home/user
RUN chmod 777 /home/user
WORKDIR /home/user

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

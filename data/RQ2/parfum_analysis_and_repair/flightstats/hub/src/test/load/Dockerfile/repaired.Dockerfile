FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreadline-gplv2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libncursesw5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tk-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdbm-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libc6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /locust
WORKDIR /locust
COPY requirements.txt /locust
RUN pip install --no-cache-dir -r requirements.txt

COPY . /locust

RUN mkdir -p /mnt/log

EXPOSE 8089 5557 5558

ENTRYPOINT ["/usr/local/bin/locust"]

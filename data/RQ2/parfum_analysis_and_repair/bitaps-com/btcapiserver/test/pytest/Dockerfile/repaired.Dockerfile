FROM ubuntu:18.04
MAINTAINER Aleksey Karpov <admin@bitaps.com>
RUN apt-get update
# install python
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip3 install --no-cache-dir --requirement requirements.txt
RUN mkdir /test
RUN mkdir /config
COPY ./ ./test
WORKDIR /test
ENTRYPOINT ["pytest"]
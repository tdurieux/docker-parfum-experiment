FROM ubuntu:18.04
MAINTAINER Aleksey Karpov <admin@bitaps.com>
RUN apt-get update

RUN apt-get -y --no-install-recommends install python3.8 python3.8-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN unlink  /usr/bin/python3;ln -s /usr/bin/python3.8 /usr/bin/python3

RUN apt-get -y --no-install-recommends install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt .
RUN pip3 install --no-cache-dir --requirement requirements.txt
RUN mkdir /config
RUN mkdir /app
COPY ./ ./app
WORKDIR /app
ENTRYPOINT ["python3", "main.py"]

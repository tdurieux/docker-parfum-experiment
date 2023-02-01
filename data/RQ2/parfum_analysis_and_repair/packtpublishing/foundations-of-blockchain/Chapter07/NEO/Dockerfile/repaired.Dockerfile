FROM ubuntu:latest

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev \
  && cd /usr/local/bin \

  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libleveldb-dev libssl-dev g++ && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir neo-python==0.6.9

ADD . /code

WORKDIR /code

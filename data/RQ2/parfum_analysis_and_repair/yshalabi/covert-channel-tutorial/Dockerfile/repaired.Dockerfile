FROM ubuntu:18.04

RUN \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y gcc && \
    apt-get install --no-install-recommends -y cmake && \
    apt-get install --no-install-recommends -y bash && \
    apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /isca19

COPY . /isca19

RUN mkdir build && cd build && cmake .. && make && ls

CMD sh isca19.sh

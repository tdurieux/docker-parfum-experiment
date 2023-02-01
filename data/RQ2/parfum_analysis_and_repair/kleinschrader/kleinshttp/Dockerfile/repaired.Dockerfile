FROM debian:stable-20210816-slim
WORKDIR /WORKDIR
RUN apt-get update && \
    apt-get --yes --no-install-recommends install make cmake g++ libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN cmake ./ && make && cp libkleinsHTTP.so libkleinsHTTP.a /usr/lib/ && cp libkleinsHTTP.h /usr/include

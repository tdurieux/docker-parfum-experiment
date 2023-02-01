FROM buildpack-deps:bionic
LABEL maintainer="Sumeet Chhetri"
LABEL version="1.0"
LABEL description="Base v docker image with master code found on 3rd July 2020 3:49PM IST"

RUN apt update -yqq && apt install -y --no-install-recommends git make && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/vlang/v && cd v && make && ./v symlink

FROM ubuntu:20.04
RUN apt update \
    && apt install -y --no-install-recommends g++ libboost-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
COPY config.compile.v1.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]
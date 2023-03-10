FROM ubuntu:20.04
RUN apt update \
    && apt install -y --no-install-recommends gcc libc-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
COPY config.compile.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]
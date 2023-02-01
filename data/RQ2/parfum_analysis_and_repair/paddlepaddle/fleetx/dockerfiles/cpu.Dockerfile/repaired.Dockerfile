ARG PADDLE_IMG=registry.baidubce.com/paddlepaddle/paddle:2.0.0

FROM ${PADDLE_IMG}

RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN apt update && \
    apt install --no-install-recommends -y procps curl wget git vim && rm -rf /var/lib/apt/lists/*;


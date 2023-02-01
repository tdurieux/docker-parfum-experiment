ARG PADDLE_IMG=registry.baidubce.com/paddlepaddle/paddle:1.8.5

FROM ${PADDLE_IMG}

RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN apt update && \
    apt install --no-install-recommends -y procps curl wget git vim && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip --no-cache-dir install -i https://mirror.baidu.com/pypi/simple --no-cache-dir \
    paddle-rec==1.8.5.1 \
    paddle-serving-client==0.4.0 \
    paddle-serving-server==0.4.0 \
    paddle-serving-app==0.3.0

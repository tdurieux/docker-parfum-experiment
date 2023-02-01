#FROM alpine
FROM swcli:latest

RUN pip install --no-cache-dir -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com pyyaml
RUN pip install --no-cache-dir requests requests_oauthlib -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com
RUN apk add --no-cache zip curl

#COPY builtin_package/build /root/build
COPY builtin_package/saas /root/saas
COPY builtin_package/chart /root/chart

RUN wget https://sreworks.oss-accelerate.aliyuncs.com/bin/mc-linux-amd64 -O /root/mc && chmod +x /root/mc

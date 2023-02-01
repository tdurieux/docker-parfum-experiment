FROM alpine:latest

MAINTAINER author="Archerx" email="xuchaoao@outlook.com"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN set -x \
    && apk update \
    && apk add --no-cache bash \
    && apk add --no-cache python3 \
    && apk add --no-cache gcc
#    && apk add redis \
#    && apk add mongodb \
#    && apk add mongodb-tools

# install xscan

RUN mkdir -p /xscan

COPY . /xscan
RUN pip3 install --no-cache-dir --upgrade pip
RUN set -x \
    && pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple -r /xscan/requirements/requirements.txt

#RUN set -x \
#    && chmod a+x /opt/w11scan/dockerconf/start.sh

WORKDIR /xscan
USER root
CMD celery -A celery_tasks.main  worker --loglevel=info -P gevent --without-heartbeat

#EXPOSE 8000
#
#CMD ["/usr/bin/tail", "-f", "/dev/null"]


## 安装依赖cryptography>=2.5报错
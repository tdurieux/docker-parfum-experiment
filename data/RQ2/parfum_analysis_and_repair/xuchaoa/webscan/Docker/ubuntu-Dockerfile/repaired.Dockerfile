# 配置基础镜像
FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends python3 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U && python3 -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

USER root


RUN apt-get autoclean && apt-get clean && apt-get autoremove
ADD . /code
WORKDIR /code

COPY requirements/requirements.txt /tmp/python3.reqs
RUN python3 -m pip install -r /tmp/python3.reqs


CMD celery -A celery_tasks.main  worker --loglevel=info -P gevent --without-heartbeat
#ENTRYPOINT [ "/bin/bash" ]

## 调试到基本差不多了
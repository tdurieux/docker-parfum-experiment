FROM python:3.7

ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install --no-install-recommends -y gettext python3-dev libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /dj-chat
#设置工作目录
WORKDIR /dj-chat
#将当前目录加入到工作目录中
#ADD . /dj-chat # 挂载卷中可以注释
ADD ./requirements.txt /dj-chat/
RUN pip install --no-cache-dir -r /dj-chat/requirements.txt -i https://mirrors.aliyun.com/pypi/simple/

EXPOSE 80 8001 8000

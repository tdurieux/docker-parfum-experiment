FROM registry.fit2cloud.com/public/python:v3
MAINTAINER Jumpserver Team <ibuler@qq.com>

COPY requirements /opt/coco/requirements
WORKDIR /opt/coco

RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN cd requirements && yum -y install $(cat rpm_requirements.txt) && rm -rf /var/cache/yum
RUN cd requirements && pip install --no-cache-dir $(egrep "jms|jumpserver" requirements.txt)
RUN cd requirements && pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/ || pip install --no-cache-dir -r requirements.txt

ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8

COPY . /opt/coco
VOLUME /opt/coco/data

RUN echo > config.yml

EXPOSE 2222
ENTRYPOINT ["./entrypoint.sh"]

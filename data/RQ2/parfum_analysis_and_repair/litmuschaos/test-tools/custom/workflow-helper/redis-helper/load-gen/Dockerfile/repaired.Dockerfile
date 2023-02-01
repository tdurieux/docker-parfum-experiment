FROM python:3

LABEL maintainer="LitmusChaos"

ARG TARGETPLATFORM

ADD redisLoad.py .
ADD redis-cmd.py .
ADD locustfile.py .

RUN pip3 install --no-cache-dir python_redis
RUN pip3 install --no-cache-dir redis
RUN pip3 install --no-cache-dir locust
RUN ls

ENTRYPOINT [ "" ]
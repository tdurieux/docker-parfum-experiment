FROM python:2.7-alpine3.7

ADD . /autohelm
RUN pip install --no-cache-dir ./autohelm

ENTRYPOINT ["autohelm"]

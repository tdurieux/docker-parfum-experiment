FROM python:3.8

WORKDIR /root

COPY . /tmp/rq

RUN pip install --no-cache-dir /tmp/rq

RUN rm -r /tmp/rq

ENTRYPOINT ["rq", "worker"]

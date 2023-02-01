FROM python:3.7.3-alpine3.9

ADD . /app

RUN pip3 install --no-cache-dir /app

ENTRYPOINT ["copyrator"]

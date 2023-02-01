FROM python:3.7-alpine

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY *requirements.txt /app/
RUN apk add --no-cache --virtual=.run-deps git && \
    pip install --no-cache-dir -r requirements.txt -r

COPY . /app

RUN python setup.py install

CMD ["crane"]
LABEL name=crane version=dev

FROM python:alpine

WORKDIR /app

COPY app/requirements.txt /app

RUN set -x \
      && apk update \
      && apk add gcc libpq-dev musl-dev  \
      && pip install -r requirements.txt \
      && apk del gcc

COPY app/ /app/

CMD [ "python", "/app/app.py"]

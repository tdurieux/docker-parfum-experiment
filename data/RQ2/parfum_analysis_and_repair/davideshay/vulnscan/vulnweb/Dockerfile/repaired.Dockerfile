FROM python:alpine

WORKDIR /app

COPY app/requirements.txt /app

RUN set -x \
      && apk update \
      && apk add --no-cache gcc libpq-dev musl-dev \
      && pip install --no-cache-dir -r requirements.txt \
      && apk del gcc

COPY app/ /app/

CMD [ "python", "/app/app.py"]

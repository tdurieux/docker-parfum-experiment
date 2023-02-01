FROM python:3.7-alpine

MAINTAINER OpenRCA

RUN apk update && \
    apk add --no-cache gcc musl-dev

WORKDIR /app

ADD ./requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

RUN pip install --no-cache-dir .

CMD [ "honcho", "start" ]

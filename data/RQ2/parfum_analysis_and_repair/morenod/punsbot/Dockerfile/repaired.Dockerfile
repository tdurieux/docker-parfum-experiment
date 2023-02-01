FROM alpine:latest
MAINTAINER morenod

RUN apk add --no-cache sqlite tzdata python python-dev py-pip build-base \
  && pip install --no-cache-dir PyTelegramBotAPI

ENV TZ="Europe/Madrid"

ADD punsbot.py /
ADD defaultpuns /defaultpuns

CMD ["python", "-u", "/punsbot.py"]

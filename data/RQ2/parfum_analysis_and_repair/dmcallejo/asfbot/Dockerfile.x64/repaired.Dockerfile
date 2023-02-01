FROM python:3.10-alpine

MAINTAINER dmcallejo

ADD requirements.txt /bot/

WORKDIR /bot

RUN pip3 install --no-cache-dir -r requirements.txt

ADD . /bot

ENTRYPOINT ["python3","bot.py"]

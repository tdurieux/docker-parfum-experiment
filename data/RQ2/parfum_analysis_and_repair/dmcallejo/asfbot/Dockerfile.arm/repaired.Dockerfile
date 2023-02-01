FROM arm32v7/python:3-slim

MAINTAINER dmcallejo

ADD requirements.txt /bot/

WORKDIR /bot

RUN pip3 install --no-cache-dir -r requirements.txt

ADD . /bot

ENTRYPOINT ["python3","bot.py"]

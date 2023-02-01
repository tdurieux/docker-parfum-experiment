FROM python:3.7-stretch

LABEL maintainer="Alexander Nwala <anwala@cs.odu.edu>"

WORKDIR /home/sumgram

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir sumgram
ENTRYPOINT ["sumgram"]
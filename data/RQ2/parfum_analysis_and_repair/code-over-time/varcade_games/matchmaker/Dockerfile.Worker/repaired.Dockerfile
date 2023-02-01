FROM python:3.8-alpine
ENV PYTHONUNBUFFERED 1

RUN apk add --no-cache bash
RUN apk add --no-cache vim

RUN mkdir /matchmaker
WORKDIR /matchmaker

ADD matchmaker ./
ADD requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

ARG server_mode=development
ENV SERVER_MODE=$server_mode
CMD python game_worker.py -m $SERVER_MODE

FROM python:3.6-alpine

MAINTAINER Adrian Moreno <adrian.moreno@emc.com>

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "python", "./listener.py" ]

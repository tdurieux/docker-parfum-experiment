FROM python:3.7-slim

WORKDIR /

RUN mkdir /storage/

ADD redditdownloader /redditdownloader
ADD requirements.txt /requirements.txt
ADD Run.py /Run.py

RUN pip install --no-cache-dir -r /requirements.txt

ENTRYPOINT [ "python", "-u", "/redditdownloader", "--settings=/storage/config/settings.json", "--docker"]

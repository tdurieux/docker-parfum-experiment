FROM tiangolo/uwsgi-nginx-flask:python3.8

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt -y upgrade
RUN groupadd -r ctf && useradd -r -g ctf ctf

WORKDIR /app
RUN pip install --no-cache-dir Flask redis

ADD ./uwsgi.ini ./
ADD ./templates ./templates
ADD ./app.py    ./

RUN chown -R root:ctf ./
RUN chmod -R 555      ./

FROM python:3.5.2
MAINTAINER Ilya Kreymer <ikreymer at gmail.com>

WORKDIR /shepherd

ADD requirements.txt /shepherd/

RUN pip install --no-cache-dir -r requirements.txt

ADD . /shepherd/

VOLUME /shepherd/static/

CMD ["uwsgi", "uwsgi.ini"]



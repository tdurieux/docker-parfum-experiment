FROM python:3.8

RUN mkdir /app
WORKDIR /app
ADD requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

ADD . /app

EXPOSE 5000

CMD gunicorn -c /app/gunicorn.conf.py main:application

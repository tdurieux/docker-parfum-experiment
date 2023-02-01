FROM python:3.7
MAINTAINER @vas3k <me@vas3k.ru>

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 1414

CMD python ./app.py

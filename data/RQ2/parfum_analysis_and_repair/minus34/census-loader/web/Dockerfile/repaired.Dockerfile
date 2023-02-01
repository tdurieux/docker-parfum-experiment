FROM python:3.6
MAINTAINER Alex Leith <aleith@crcsi.com.au>


ADD ./ /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

CMD python3 server.py

FROM python:2.7
ENV PYTHONBUFFERRED 1
RUN pip install --no-cache-dir --upgrade pip

RUN mkdir /demo

WORKDIR /demo/
ADD demo/requirements.txt /demo/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ADD demo /demo/


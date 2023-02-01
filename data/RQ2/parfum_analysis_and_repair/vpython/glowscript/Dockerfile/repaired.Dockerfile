FROM python:3.8.5-buster

RUN mkdir /app

WORKDIR /app

COPY ./requirements.txt /app

RUN pip install --no-cache-dir -U pip

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

CMD flask run




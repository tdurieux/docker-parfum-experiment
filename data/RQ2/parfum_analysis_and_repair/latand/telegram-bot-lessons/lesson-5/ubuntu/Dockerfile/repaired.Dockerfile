FROM python:latest

RUN mkdir /src
WORKDIR /src
COPY . /src
RUN pip install --no-cache-dir -r requirements.txt

FROM python:latest

RUN mkdir /src
WORKDIR /src
COPY requirements.txt /src/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /src
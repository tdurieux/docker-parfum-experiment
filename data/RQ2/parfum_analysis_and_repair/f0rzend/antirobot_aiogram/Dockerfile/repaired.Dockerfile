FROM python:3.8.3

RUN mkdir -p /usr/src/antirobot && rm -rf /usr/src/antirobot
WORKDIR /usr/src/antirobot

COPY . /usr/src/antirobot

RUN pip install --no-cache-dir -r requirements.txt
FROM python:3.9-slim-bullseye

COPY ./ /passivbot/

WORKDIR /passivbot

RUN pip install --no-cache-dir -r requirements_liveonly.txt

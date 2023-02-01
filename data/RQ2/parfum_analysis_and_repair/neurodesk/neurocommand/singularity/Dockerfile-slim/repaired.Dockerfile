FROM python:3.9.1-slim-buster

RUN mkdir -p /neurocommand
COPY neurodesk/requirements.txt /neurocommand/
WORKDIR /neurocommand

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /neurocommand
# RUN python -m neurodesk --cli

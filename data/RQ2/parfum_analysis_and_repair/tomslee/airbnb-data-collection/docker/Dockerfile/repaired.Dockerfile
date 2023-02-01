FROM continuumio/miniconda3:4.5.4

COPY ./*.py collector/
COPY ./docker/requirements.txt collector/

RUN apt-get update

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r collector/requirements.txt

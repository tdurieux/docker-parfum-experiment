FROM python:3

WORKDIR /app

COPY ./requirements.txt requirements.txt

RUN pip install --no-cache-dir -U pip && pip install --no-cache-dir --upgrade pip setuptools \
    && pip install --no-cache-dir -r requirements.txt

COPY  . /app

ENV PYTHONPATH "${PYTHONPATH}:/app"

ENV MESSAGE "Hail Hydra"
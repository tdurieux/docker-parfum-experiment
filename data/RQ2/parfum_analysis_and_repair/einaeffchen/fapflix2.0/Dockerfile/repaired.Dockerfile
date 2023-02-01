FROM python:3.7.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir psycopg2

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
COPY fapflix /srv/data/fapflix
WORKDIR /srv/data/fapflix
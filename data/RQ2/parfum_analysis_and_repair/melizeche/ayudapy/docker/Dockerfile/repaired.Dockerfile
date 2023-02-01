FROM python:3.7-buster

ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
 apt-get install --no-install-recommends gdal-bin postgresql-client -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /code

WORKDIR /code

COPY requirements.txt /code/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /code/

EXPOSE 8000

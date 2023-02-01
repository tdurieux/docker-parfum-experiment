FROM python:3.5-jessie

RUN apt-get update && apt-get install -y --no-install-recommends \
      libav-tools \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

ADD requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN pip install --no-cache-dir -e .

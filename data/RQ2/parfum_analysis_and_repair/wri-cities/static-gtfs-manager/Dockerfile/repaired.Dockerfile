FROM python:3.6-slim-stretch

RUN apt-get update && apt-get -y upgrade && \
    apt-get install --no-install-recommends -y python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app
COPY . /app/
RUN pip3 install --no-cache-dir -r requirements.txt --user

EXPOSE 5000

CMD cd /app/ && python3 GTFSManager.py

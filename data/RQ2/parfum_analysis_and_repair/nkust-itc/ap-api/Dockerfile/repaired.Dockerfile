# Base image
FROM python:3.6
# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN pip3 install --no-cache-dir -r ./requirements.txt

RUN apt-get update && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app/src
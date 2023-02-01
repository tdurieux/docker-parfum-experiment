FROM ubuntu:16.04

# If you have hash mismatch issue, uncomment this line
# RUN rm -rf /var/lib/apt/lists/* && apt clean

RUN apt update && apt install --no-install-recommends -y wget tar python python-pip curl libcurl4-openssl-dev locales && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/app

WORKDIR /usr/app

RUN apt install --no-install-recommends -y ffmpeg postgresql-client python-dev libyaml-dev python-psycopg2 openssl python-imaging && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y build-essential libssl-dev libffi-dev deluged nodejs && rm -rf /var/lib/apt/lists/*;

COPY Albireo/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

RUN useradd -u 1000 --create-home user

RUN chown user:user -R /usr/app

RUN mkdir -p /data

RUN chown user:user -R /data

USER user

COPY Albireo/ /usr/app/

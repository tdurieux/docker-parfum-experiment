FROM ubuntu:bionic

RUN apt update && apt --assume-yes dist-upgrade && apt --assume-yes -y --no-install-recommends install mysql-server nodejs npm redis supervisor && npm install -g npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

ENV DATABASE_PASSWORD=$DATABASE_PASSWORD

WORKDIR /app

COPY . /app

RUN bin/install

RUN deployments/standalone/initialise_db.sh

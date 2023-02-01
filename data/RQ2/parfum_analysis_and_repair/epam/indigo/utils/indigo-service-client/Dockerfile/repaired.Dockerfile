FROM node:12-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    git && rm -rf /var/lib/apt/lists/*;

#RUN npm install gulp -g

WORKDIR /code


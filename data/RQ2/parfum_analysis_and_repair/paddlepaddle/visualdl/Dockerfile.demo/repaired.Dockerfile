FROM nikolaik/python-nodejs:python3.8-nodejs14 AS builder

WORKDIR /home/visualdl
COPY . .

RUN apt-get update && apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*
RUN ["pip", "install", "--disable-pip-version-check", "-r", "requirements.txt"]
RUN ["python", "setup.py", "bdist_wheel"]
RUN ["pip", "install", "--disable-pip-version-check", "--find-links=dist", "visualdl"]

WORKDIR /home/visualdl/frontend

ENV SCOPE server
ENV PUBLIC_PATH /paddle/visualdl/demo
ENV TELEMETRY_ID b281676ad3824647971c6fd92d65f642

RUN ["./scripts/install.sh"]
RUN ["./scripts/build.sh"]


FROM node:14-alpine

WORKDIR /home/visualdl
COPY --from=builder /home/visualdl/frontend/output/server.tar.gz /tmp

ENV NODE_ENV production
ENV PING_URL /ping
ENV DEMO true
ENV HOST 0.0.0.0
ENV PORT 8999

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --virtual .build-deps git && \
    tar zxf /tmp/server.tar.gz && \
    rm /tmp/server.tar.gz && \
    yarn install --no-lockfile && \
    yarn cache clean && \
    apk del --no-network .build-deps

ENTRYPOINT ["yarn", "start"]
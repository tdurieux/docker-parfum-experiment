FROM node:16-bullseye-slim

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN apt-get update && apt-get install --no-install-recommends gcc g++ make cmake python3 python3-pip ffmpeg -y && rm -rf /var/lib/apt/lists/*;

RUN npm ci

COPY . .

RUN npm run build

FROM node:lts

RUN apt-get update && apt-get install -y build-essential git python make g++

RUN mkdir -p /workspace /results

WORKDIR /workspace

COPY workspace /workspace

RUN npm install

CMD npx ts-node index.ts

FROM node:lts

RUN apt-get update && apt-get install --no-install-recommends -y build-essential git python make g++ && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /workspace /results

WORKDIR /workspace

COPY workspace /workspace

RUN npm install && npm cache clean --force;

CMD npx ts-node index.ts

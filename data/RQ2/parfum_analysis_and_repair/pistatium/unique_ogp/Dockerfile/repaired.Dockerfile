FROM node:12-slim

RUN apt-get update -y && apt-get install --no-install-recommends -y python3 build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && rm -rf /var/lib/apt/lists/*;

ADD src /opt/node/js
WORKDIR /opt/node/js

RUN ["/bin/bash", "-c", "npm install"]

ENTRYPOINT node index.js

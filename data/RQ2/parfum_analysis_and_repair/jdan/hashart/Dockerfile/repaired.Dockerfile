FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
# https://www.npmjs.com/package/canvas
RUN apt-get install --no-install-recommends -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
ADD . .
RUN npm install --build-from-source && npm cache clean --force;

CMD ["node", "server.js"]

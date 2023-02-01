FROM node:8

RUN apt-get update && apt-get install -y --no-install-recommends -qq libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /jsbarcode
WORKDIR /jsbarcode
COPY ./ ./

RUN npm install && npm cache clean --force;

CMD npm test

EXPOSE 3000

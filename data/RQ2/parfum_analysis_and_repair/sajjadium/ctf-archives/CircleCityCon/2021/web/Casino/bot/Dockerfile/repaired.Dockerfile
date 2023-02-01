FROM node:16-buster-slim

RUN apt-get update && \
 apt-get install --no-install-recommends -y chromium dumb-init && \
rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production \
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

RUN addgroup inmate && \
adduser --disabled-password --gecos "" --ingroup inmate inmate

WORKDIR /home/inmate/app
COPY . ./

RUN chown -R inmate:inmate .
USER inmate
RUN npm install && \
mkdir -p /home/inmate/Downloads && npm cache clean --force;

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "./app.js"]

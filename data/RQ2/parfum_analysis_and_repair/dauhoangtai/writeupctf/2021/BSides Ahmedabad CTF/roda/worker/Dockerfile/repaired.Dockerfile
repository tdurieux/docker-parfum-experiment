FROM node:16-slim

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget gnupg ca-certificates procps libxss1 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y google-chrome-unstable && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json ./
RUN PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm install && npm cache clean --force;

RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app/node_modules

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

USER pptruser
COPY index.js ./

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "index.js"]

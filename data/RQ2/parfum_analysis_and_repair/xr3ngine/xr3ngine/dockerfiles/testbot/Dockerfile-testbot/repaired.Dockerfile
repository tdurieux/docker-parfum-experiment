# not slim because we need github depedencies
FROM root-builder as builder

# Create app directory
WORKDIR /app

RUN npm install --loglevel notice --legacy-peer-deps && npm cache clean --force;
# copy then compile the code
COPY . .

ENV APP_ENV=production

FROM node:16-buster-slim as runner

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app ./

CMD ["scripts/start-testbot.sh"]
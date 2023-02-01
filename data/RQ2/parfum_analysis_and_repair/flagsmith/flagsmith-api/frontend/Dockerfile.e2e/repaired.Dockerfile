FROM node:16

RUN mkdir /srv/flagsmith && chown node:node /srv/flagsmith

RUN apt-get update && apt install --no-install-recommends -y ./google-chrome*.deb -f && rm -rf /var/lib/apt/lists/*;
RUN wget https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_96.0.4664.110-1_amd64.deb

RUN apt-get clean

WORKDIR /srv/flagsmith

COPY --chown=node:node . .

RUN npm install --quiet && npm cache clean --force;
ENV ENV=e2e
RUN npm i && npm run env && npm cache clean --force;

EXPOSE 8080
CMD ["npm",  "run", "test"]

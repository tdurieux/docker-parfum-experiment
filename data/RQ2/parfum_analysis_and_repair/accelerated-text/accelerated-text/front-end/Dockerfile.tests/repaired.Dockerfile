FROM node:11-slim

RUN apt-get update -qq && apt-get install --no-install-recommends -y -qq build-essential chromium libatk-bridge2.0-0 libgtk-3-0 libnss3 && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/tests && rm -rf /usr/src/tests
WORKDIR /usr/src/tests

COPY tests/ /usr/src/tests
COPY wait-for-it.sh wait-for-it.sh

RUN chmod +x wait-for-it.sh

RUN npm install puppeteer && npm cache clean --force;
RUN npm install && npm cache clean --force;

CMD ["npm", "run", "bdd"]
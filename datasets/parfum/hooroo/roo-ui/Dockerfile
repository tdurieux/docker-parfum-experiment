FROM node:16-buster-slim@sha256:64dc41bcf5e9048aa1b9a6efe3af68631720e6b76e98f281a77d305e898d3610

# Install Google Chrome for Puppeteer
RUN  apt-get update \
    && apt-get install -y git wget gnupg ca-certificates procps libxss1 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* \
    && wget --quiet https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh \
    && chmod +x /usr/sbin/wait-for-it.sh

WORKDIR /application

COPY package.json yarn.lock ./
RUN yarn add puppeteer
RUN yarn

COPY . .

CMD ["yarn", "storybook"]

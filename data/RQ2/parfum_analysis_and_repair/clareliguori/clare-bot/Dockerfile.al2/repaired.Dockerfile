FROM public.ecr.aws/amazonlinux/amazonlinux:2

WORKDIR /opt/app

# Install Node.js
ENV NODE_VERSION 16.13.1
RUN yum install -y tar xz && rm -rf /var/cache/yum
RUN curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt" \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt

# Install npm modules and compile Typescript code
COPY package.json package-lock.json ./
RUN npm ci

COPY bot.ts tsconfig.json ./
RUN npm run build

# Command to run when container starts
CMD [ "node", "dist/bot.js" ]

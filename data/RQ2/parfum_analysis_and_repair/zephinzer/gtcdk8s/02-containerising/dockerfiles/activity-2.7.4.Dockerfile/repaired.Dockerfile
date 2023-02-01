FROM ubuntu:16.04
WORKDIR /app
COPY ./example-app/package.json /app/package.json
COPY ./example-app/package-lock.json /app/package-lock.json
RUN apt-get update \
  && apt-get install --no-install-recommends -y nodejs npm \
  && ln -s /usr/bin/nodejs /usr/bin/node \
  && npm install \
  && apt-get -y remove nodejs npm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
COPY ./example-app /app
ENTRYPOINT ["node", "index.js"]
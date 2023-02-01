FROM ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl patch && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY package.json /app/

RUN npm install && npm cache clean --force;

COPY . /app/

RUN npm run build

CMD [ "npm", "run", "start" ]

HEALTHCHECK --start-period=5s --retries=10 CMD curl --fail http://localhost:3000/ping || exit 1
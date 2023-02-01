# manual way of starting the container (otherwise see docker-compose.ui.yml):
# docker build -f Dockerfile.ui.dev -t tzetzo/ui .
# docker run -p 3003:3000 tzetzo/ui

FROM debian:buster

WORKDIR /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y nodejs && \
    apt-get install --no-install-recommends -y npm --fix-missing && \
    apt-get install --no-install-recommends -y ssh rsync && rm -rf /var/lib/apt/lists/*;

COPY . .

WORKDIR /app/ui

RUN npm install && npm cache clean --force;

CMD ["npm", "start"]

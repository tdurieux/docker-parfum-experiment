FROM node:8

WORKDIR /app

COPY . /app

EXPOSE 3002
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && apt-get install --no-install-recommends -y python && npm install && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

CMD ["npm","start"]


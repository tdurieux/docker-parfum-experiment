FROM node:16-bullseye

RUN apt update && apt install --no-install-recommends -y python2 && rm -rf /var/lib/apt/lists/*;
RUN npm config set python python2
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

CMD ["./docker/local/cms/run.sh"]

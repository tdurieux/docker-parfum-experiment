FROM node:8-slim

WORKDIR /app/RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ffmpeg \
    && ls /var/lib/apt/lists \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install -q \
    && npm prune --production && npm cache clean --force;

# copy all files from the root of this module, relying on .dockerignore to filter out undesirable files
COPY . .

EXPOSE 3000 3001 3002

EXPOSE 9229

CMD ["node", "--inspect=0.0.0.0:9229", "./bin/www"]

FROM node:14

WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;

RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

COPY . .
CMD ["bash", ".docker/start.sh"]
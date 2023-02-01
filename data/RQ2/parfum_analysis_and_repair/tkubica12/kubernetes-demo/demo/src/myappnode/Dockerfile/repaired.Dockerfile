FROM node:10

RUN apt update && apt install --no-install-recommends jq -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN chmod +x /app/start.sh

EXPOSE 3000
ENTRYPOINT [ "/app/start.sh" ]
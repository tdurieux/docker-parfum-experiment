FROM node:16-slim

WORKDIR /var/www/app

# OS TOOLS
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*; COPY . .



RUN npm ci --quiet

EXPOSE 3000

CMD [ "npm", "run", "start:prod" ]

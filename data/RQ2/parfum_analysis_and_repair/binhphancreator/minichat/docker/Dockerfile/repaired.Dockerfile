FROM node:latest

# Install system dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    curl \
    nano && rm -rf /var/lib/apt/lists/*;

#Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#Install pm2 globally
RUN npm i pm2 -g && npm cache clean --force;
FROM node:8

# Create app directory
WORKDIR /home/node

COPY apis.zip .

RUN apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;

RUN unzip apis.zip && rm apis.zip

RUN npm install && npm cache clean --force;

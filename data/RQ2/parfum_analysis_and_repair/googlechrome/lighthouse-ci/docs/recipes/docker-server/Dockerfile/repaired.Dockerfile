FROM node:14-bullseye-slim

# Install utilities
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y python build-essential && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/lhci
COPY package.json .
COPY lighthouserc.json .
RUN npm install && npm cache clean --force;

EXPOSE 9001
CMD [ "npm", "start" ]

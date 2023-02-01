FROM node:16

WORKDIR /app
COPY . .
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y lsof && rm -rf /var/lib/apt/lists/*;
RUN npm i -g npm typescript && npm cache clean --force;
RUN npm install --development --force && npm cache clean --force;
RUN npm run build
CMD npm start

FROM node:16
WORKDIR /opt/lavamusic/

# Copy dependencies first to improve layer caching
COPY package*.json ./
RUN npm install --production && npm cache clean --force;

COPY . .

CMD [ "npm", "start" ]

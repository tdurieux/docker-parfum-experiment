# To test the container locally you can run:
# docker build -f obstacle_crawler/Dockerfile.obstacle . -t obstacle_crawler
# docker run -v $(pwd)/config.py:/mnt/config/config.py obstacle_crawler

FROM node:14-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY ./obstacle_crawler/package*.json ./

RUN npm install && npm cache clean --force;
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY ./obstacle_crawler/ .

# Don't leak our data
# COPY ./config.py .

CMD [ "node", "main.js" ]
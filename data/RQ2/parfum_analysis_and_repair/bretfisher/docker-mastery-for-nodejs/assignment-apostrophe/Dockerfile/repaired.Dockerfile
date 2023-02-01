FROM node:carbon

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Bundle app source
COPY . /app
RUN npm install && npm cache clean --force;

# Mount persistent storage
VOLUME /app/data
VOLUME /app/public/uploads

EXPOSE 3000
CMD [ "npm", "start" ]

FROM node:0.12.2

# Bundle app source
COPY . /app
# Install app dependencies
RUN cd /app; npm install && npm cache clean --force;

EXPOSE 5000
CMD ["node", "/app/server.js"]

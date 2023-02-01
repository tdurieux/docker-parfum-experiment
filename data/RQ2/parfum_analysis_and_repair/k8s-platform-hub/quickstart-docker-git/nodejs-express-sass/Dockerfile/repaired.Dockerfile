FROM mhart/alpine-node:7.6.0
WORKDIR /src
# Add app source files
ADD app/src /src
#install node modules
RUN npm install --only=production && npm cache clean --force;

CMD ["node", "server.js"]

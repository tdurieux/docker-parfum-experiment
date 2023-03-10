FROM alpine:latest

#RUN apk add --update npm
RUN apk add --no-cache --update nodejs

# Define app directory
ENV APPDIR=/app
ENV NODE_ENV=production

# Create app directory
WORKDIR /app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY webroot webroot
COPY node_modules node_modules
RUN unlink node_modules/drp-mesh
RUN unlink node_modules/drp-service-rsage
RUN unlink node_modules/drp-service-test
COPY drp-mesh node_modules/drp-mesh
COPY drp-service-rsage node_modules/drp-service-rsage
COPY drp-service-test node_modules/drp-service-test
COPY package.json .
COPY server.js .
COPY drpRegistry.js .
COPY drpBroker.js .
COPY drpConsumer.js .
COPY drpProvider-Test-NoListener.js .

# RUN npm install --production
# If you are building your code for production
# RUN npm ci --only=production

LABEL cisco.info.name="drp-nodejs-small" \
      cisco.info.description="DRP Node.js Server" \
      cisco.info.version="latest" \
      cisco.info.author-link="https://adhdtech.com" \
      cisco.info.author-name="Pete Brown" \
      cisco.type=docker \
      cisco.cpuarch=x86_64 \
      cisco.resources.profile=custom \
      cisco.resources.cpu=400 \
      cisco.resources.memory=128 \
      cisco.resources.disk=128 \
      cisco.resources.network.0.interface-name=eth0 \
      cisco.resources.network.0.ports.tcp=[8080]

EXPOSE 8080
CMD [ "node", "server.js" ]

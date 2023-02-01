FROM node:10

# Create app directory, make it owned by node:node
WORKDIR /usr/src/app
RUN chown node:node /usr/src/app

# Don't run as root anymore
USER node

# Copy in package*.json first, then npm install if not cached.
COPY --chown=node:node package*.json ./
RUN npm install

# Bundle app source, owned by node:node
COPY --chown=node:node . .

# Run app
ENTRYPOINT ["/bin/sh"]
CMD ["./app-start.sh"]
FROM node:16.9

WORKDIR /usr/src/

# Copy source
COPY . .

# Install dependencies
RUN yarn install --production && yarn cache clean;

# Expose ports
EXPOSE 8080
EXPOSE 8081

# Run servicce
CMD [ "node", "index.js" ]

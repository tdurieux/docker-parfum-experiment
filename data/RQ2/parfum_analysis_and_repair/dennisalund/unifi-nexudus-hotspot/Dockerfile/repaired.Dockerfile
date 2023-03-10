FROM node:6.11-alpine

ENV PORT=80

# Create app directory
RUN mkdir -p /hotspot
COPY ./src /hotspot
COPY ./LICENSE /hotspot
WORKDIR /hotspot

# Install tools
RUN npm install -g typescript@^2 && npm cache clean --force;

# Install packages and build
RUN npm install \
    && tsc -p . \
    && npm prune --production && npm cache clean --force;

EXPOSE ${PORT}

ENTRYPOINT [ "npm", "run" ]
CMD ["start"]
# Install the app dependencies in a full Node docker image
FROM node:12

# librdkafka builds against libssl-dev
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Copying individual files/folders as buildah 1.9.0 does not honour .dockerignore
COPY package*.json /project/
COPY *.js /project/
COPY user-app /project/user-app
# Removing node_modules as we can not make assumptions about file structure of user-app
RUN rm -rf /project/user-app/node_modules && mkdir -p /project/user-app/node_modules

# Install stack dependencies
WORKDIR /project
RUN npm install --production && npm cache clean --force;

# Install user-app dependencies
WORKDIR /project/user-app
RUN npm install --production && npm cache clean --force;

# Creating a tar to work around poor copy performance when using buildah 1.9.0
RUN cd / && tar czf project.tgz project

# Copy the dependencies into a slim Node docker image
FROM node:12-slim

# librdkafka links against libssl
RUN apt-get update && apt-get install --no-install-recommends -y libssl1.1 ca-certificates && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Copy project with dependencies
COPY --chown=node:node --from=0 /project.tgz /
RUN tar xf project.tgz && chown -R node:node /project && rm project.tgz
WORKDIR /project

ENV NODE_PATH=/project/user-app/node_modules

ENV NODE_ENV production
ENV PORT 3000

USER node

EXPOSE 3000
CMD ["npm", "start"]

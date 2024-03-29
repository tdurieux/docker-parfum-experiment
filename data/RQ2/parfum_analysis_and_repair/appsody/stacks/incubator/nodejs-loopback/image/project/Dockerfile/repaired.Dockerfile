# Install the app dependencies in a full Node docker image
FROM node:12

# Copying individual files/folders as buildah 1.9.0 does not honour .dockerignore
COPY *.json /project/
COPY user-app /project/user-app
COPY src /project/src

# Removing node_modules as we can not make assumptions about file structure of user-app
RUN rm -rf /project/user-app/node_modules && mkdir -p /project/user-app/node_modules

# Install stack dependencies
WORKDIR /project
RUN npm install && npm cache clean --force;

# Install user-app dependencies
WORKDIR /project/user-app
# RUN `npm install` instead of `npm install --production` as we need to transpile TS code
RUN npm install && npm cache clean --force;

# Creating a tar to work around poor copy performance when using buildah 1.9.0
RUN cd / && tar czf /project.tgz project

# Copy the dependencies into a slim Node docker image
FROM node:12-slim

# Copy project with dependencies
COPY --chown=node:node --from=0 /project.tgz /
RUN tar xf project.tgz && chown -R node:node /project && rm project.tgz
WORKDIR /project

# Make sure TypeScript source code is transpiled
RUN npm run build && npm run build --prefix user-app

ENV NODE_ENV production
ENV PORT 3000

USER node

CMD ["npm", "start"]

ARG NODE_VERSION

FROM node:${NODE_VERSION} AS build

COPY . /spooky

WORKDIR /spooky
RUN npm cache clean --force
RUN rm -rf node_modules
RUN npm install && npm cache clean --force;

FROM node:${NODE_VERSION}
WORKDIR /spooky
COPY --from=build /spooky /spooky

ENTRYPOINT ["npm", "run", "dev"]

# base image
FROM node:13-buster

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY app/public /app/public
COPY app/src /app/src
COPY app/package.json /app/
RUN rm -rf /app/node_modules /app/package-lock.json
RUN npm install && npm cache clean --force;
RUN npm install -g serve && npm cache clean --force;

# Run the production build
CMD ["serve", "-s", "build"]

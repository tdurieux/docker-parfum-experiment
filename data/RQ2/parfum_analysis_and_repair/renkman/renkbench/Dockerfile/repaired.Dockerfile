FROM node:13 AS base

RUN npm version

ARG BUILDNUMBER=1

# Create app directory
WORKDIR /usr/src/app

# Bundle app source
COPY ./app .

# Copy app data
COPY ./data ../data

# Set the build number
ENV BUILDNUMBER=${BUILDNUMBER}


FROM base as test
RUN npm install && npm cache clean --force;
ENTRYPOINT [ "npm", "test" ]


FROM base as app
RUN npm install --production && npm cache clean --force;
EXPOSE 80
CMD [ "npm", "start" ]
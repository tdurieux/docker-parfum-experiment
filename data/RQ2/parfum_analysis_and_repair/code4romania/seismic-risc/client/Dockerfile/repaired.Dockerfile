# base image
FROM node:12-alpine

ARG ENVIRONMENT

ENV ENVIRONMENT ${ENVIRONMENT:-production}
ENV NODE_ENV ${ENVIRONMENT}

# set working directory
WORKDIR /code

# add `/code/node_modules/.bin` to $PATH
ENV PATH /code/node_modules/.bin:${PATH}

# install and cache app dependencies
COPY ./package*.json ./
RUN if [ "${ENVIRONMENT}" = "production" ]; then \
 npm install --production; npm cache clean --force; else npm install; npm cache clean --force; fi

COPY ./docker-entrypoint /
COPY ./ /code/

ENTRYPOINT ["/docker-entrypoint"]

# start app
CMD ["npm", "start"]

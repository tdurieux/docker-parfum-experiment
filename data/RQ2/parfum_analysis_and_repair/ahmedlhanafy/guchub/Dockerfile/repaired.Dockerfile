# pull official base image
FROM node:13.12.0-alpine

# set working directory
WORKDIR ./app


# add app
COPY . ./

# install app dependencies
RUN yarn && yarn cache clean;
RUN yarn web:build && yarn cache clean;

# start app
CMD ["yarn", "web:serve"]
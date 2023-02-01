# Build APP with node
FROM node:lts-alpine as build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

# build dependencies
COPY package.json yarn.lock /app/
RUN yarn

# setup build options
ARG REACT_APP_LOCAL_BACKEND
ARG REACT_APP_API_URL
ARG REACT_APP_CHARTIS_URL
ARG REACT_APP_EDITOAST_URL

# build the app
COPY . /app
RUN REACT_APP_LOCAL_BACKEND=$REACT_APP_LOCAL_BACKEND \
    REACT_APP_API_URL=$REACT_APP_API_URL \
    REACT_APP_CHARTIS_URL=$REACT_APP_CHARTIS_URL \
    REACT_APP_EDITOAST_URL=$REACT_APP_EDITOAST_URL \
    yarn build

# Copy & serve app
# Stage 1 - the build process
FROM node as build-deps
ENV REACT_APP_HUSKYCI_FE_API_ADDRESS http://127.0.0.1:8888
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn build

# Stage 2 - the production environment
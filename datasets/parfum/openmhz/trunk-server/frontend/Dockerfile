# build environment
FROM node:13.12.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
ARG REACT_APP_BACKEND_SERVER
ARG REACT_APP_SITE_NAME
ARG REACT_APP_FRONTEND_SERVER
ARG NODE_ENV
COPY package.json ./
RUN npm install
RUN npm install react-scripts@3.4.1 -g --silent
COPY . ./
RUN npm run build

# production environment
FROM node:13.12.0-alpine
RUN mkdir -p /app/public
COPY ./package.json /tmp
RUN cd /tmp && npm install
RUN cp -a /tmp/node_modules /app
WORKDIR /app
COPY server /app
COPY --from=build /app/build /app/public
RUN sed 's/<meta name="temp" conent="replace"\/>/<%- TWITTER_META%>/g' /app/public/index.html > /app/index.ejs
CMD ["node", "index.js"]
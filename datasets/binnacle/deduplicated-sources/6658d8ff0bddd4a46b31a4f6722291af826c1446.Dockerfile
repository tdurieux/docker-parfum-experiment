# build environment
FROM node:9.4 as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
ARG REACT_APP_USERS_SERVICE_URL
ENV REACT_APP_USERS_SERVICE_URL $REACT_APP_USERS_SERVICE_URL
ARG REACT_APP_EXERCISES_SERVICE_URL
ENV REACT_APP_EXERCISES_SERVICE_URL $REACT_APP_EXERCISES_SERVICE_URL
ARG REACT_APP_API_GATEWAY_URL
ENV REACT_APP_API_GATEWAY_URL $REACT_APP_API_GATEWAY_URL
ARG REACT_APP_SCORES_SERVICE_URL
ENV REACT_APP_SCORES_SERVICE_URL $REACT_APP_SCORES_SERVICE_URL
COPY package.json /usr/src/app/package.json
RUN npm install --silent
RUN npm install react-scripts@1.1.0 -g --silent
COPY . /usr/src/app
RUN npm run build

# production environment
FROM nginx:1.13.5-alpine
RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

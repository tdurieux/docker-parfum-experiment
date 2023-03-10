#### Stage 1: Build the react application
FROM node:12.13-alpine as build

WORKDIR /app

# Copy the package.json as well as the yarn.lock and install
# the dependencies. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

# Copy the main application
COPY . ./

ARG REACT_APP_API_NAME
ENV REACT_APP_API_NAME=${REACT_APP_API_NAME}

ARG REACT_APP_WS_NAME
ENV REACT_APP_WS_NAME=${REACT_APP_WS_NAME}

# Build the application
RUN yarn run build

#### Stage 2: Serve the React application from Nginx
FROM nginx:1.17.0-alpine

ARG BACKEND_NAME
ENV BACKEND_NAME=${BACKEND_NAME}

ARG FRONTEND_NAME
ENV FRONTEND_NAME=${FRONTEND_NAME}

ENV SUBSTVARS='$BACKEND_NAME:$PORT'

# Copy the react build from Stage 1
COPY --from=build /app/build /var/www

# Copy our custom nginx config
COPY nginx.conf.template /etc/nginx/nginx.conf.template

CMD  envsubst "$SUBSTVARS" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g 'daemon off;'

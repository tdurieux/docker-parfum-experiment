FROM node:14
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
ARG APP_MOUNT_URI
ARG API_URI
ARG MARKETPLACE_URL
ARG STATIC_URL
ENV API_URI ${API_URI:-http://localhost:8000/graphql/}
ENV APP_MOUNT_URI ${APP_MOUNT_URI:-/}
ENV STATIC_URL ${STATIC_URL:-/}

EXPOSE 9000
CMD npm start -- --host 0.0.0.0

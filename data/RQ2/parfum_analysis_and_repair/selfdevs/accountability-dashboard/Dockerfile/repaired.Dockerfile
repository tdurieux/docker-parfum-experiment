FROM node:16

WORKDIR /app/frontend
COPY /frontend/package.json .
COPY /frontend/yarn.lock .
RUN yarn && yarn cache clean;

WORKDIR /app/backend
COPY /backend/package.json .
COPY /backend/yarn.lock .
RUN yarn && yarn cache clean;

WORKDIR /app/frontend
COPY /frontend .
RUN yarn build && yarn cache clean;

WORKDIR /app/backend
COPY /backend .
RUN yarn build && yarn cache clean;
CMD yarn serve

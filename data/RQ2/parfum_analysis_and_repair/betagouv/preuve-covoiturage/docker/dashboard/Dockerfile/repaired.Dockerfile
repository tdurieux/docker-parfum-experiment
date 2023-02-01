FROM node:16.13-alpine

RUN mkdir -p /app/shared
RUN mkdir -p /app/dashboard

WORKDIR /app/dashboard
RUN yarn install && yarn cache clean;

EXPOSE 4200
CMD ["yarn", "start", "--port=4200", "--disable-host-check", "--host=0.0.0.0"]

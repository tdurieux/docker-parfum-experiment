FROM node:14-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY . .
RUN yarn && yarn cache clean;
CMD yarn start
EXPOSE 2369

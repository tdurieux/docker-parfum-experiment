FROM node:11-alpine

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY cesi/ui/yarn.lock /app/yarn.lock
COPY cesi/ui/package.json /app/package.json
RUN yarn

COPY cesi/ui/ /app

EXPOSE 3000
ENTRYPOINT ["yarn"]
CMD ["start"]

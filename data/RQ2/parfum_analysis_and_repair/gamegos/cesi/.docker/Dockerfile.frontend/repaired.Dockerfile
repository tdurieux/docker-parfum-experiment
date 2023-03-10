FROM node:14.4.0-alpine3.12

WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

COPY cesi/ui/yarn.lock yarn.lock
COPY cesi/ui/package.json package.json
RUN yarn

COPY cesi/ui/ .

EXPOSE 3000
ENTRYPOINT ["yarn"]
CMD ["start"]
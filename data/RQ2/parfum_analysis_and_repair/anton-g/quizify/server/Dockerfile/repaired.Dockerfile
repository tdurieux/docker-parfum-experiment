FROM mhart/alpine-node:11 AS builder

COPY . .
RUN npm install && npm cache clean --force;
RUN npm run build

EXPOSE 3000

ENTRYPOINT [ "npm" ]
CMD ["run", "start"]
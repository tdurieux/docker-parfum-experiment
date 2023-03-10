ARG NODE=node:12.8.0
FROM $NODE

EXPOSE 3030
ENV BEHAVIOR_API_HOST=0.0.0.0
ENV LOG=1

WORKDIR /app

COPY . ./

RUN yarn install && ./bin/cli behaviors -c ./behavior-config.yml -b && yarn cache clean;

VOLUME ["/app/behaviors", "/app/build", "/app/dist", "/app/lib"]

CMD ["node", "./api/run.js"]

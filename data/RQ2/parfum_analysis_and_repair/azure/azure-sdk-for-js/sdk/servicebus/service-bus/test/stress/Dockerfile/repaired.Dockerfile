# public OSS users should simply leave this argument blank or ignore its presence entirely
ARG REGISTRY=""
FROM ${REGISTRY}node:12-alpine
RUN mkdir -p /app/src/
ADD ./app/src/*.ts /app/src/
ADD ./app/package.json /app/package.json
ADD ./app/tsconfig.json /app/tsconfig.json
WORKDIR /app
RUN npm install && npm run build && npm cache clean --force;
RUN ls
ENTRYPOINT ["node"];

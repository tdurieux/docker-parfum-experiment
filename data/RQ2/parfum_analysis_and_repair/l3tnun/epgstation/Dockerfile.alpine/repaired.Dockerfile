# 詳細については、Dockerfile.debianのコメントを参照。
FROM --platform=$BUILDPLATFORM node:16-alpine3.13 AS client-builder
COPY client/package*.json /app/client/
WORKDIR /app/client
RUN npm install --no-save --loglevel=info && npm cache clean --force;
COPY . /app/
RUN npm run build --loglevel=info

FROM node:16-alpine3.13 AS server-builder
RUN apk add --no-cache g++ make pkgconf python3
WORKDIR /app
COPY package*.json /app/
RUN npm config set python `which python3`
ENV DOCKER="YES"
RUN npm install --no-save --loglevel=info && npm cache clean --force;
COPY . .
RUN rm -rf client
RUN npm run build-server --loglevel=info

FROM node:16-alpine3.13
LABEL maintainer="l3tnun"
COPY --from=server-builder /app /app/
COPY --from=client-builder /app/client /app/client/
EXPOSE 8888
WORKDIR /app
ENTRYPOINT ["npm"]
CMD ["start"]

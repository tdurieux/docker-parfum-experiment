FROM node:16 AS build-env
ADD . /app
WORKDIR /app
RUN npm i && npm cache clean --force;

FROM gcr.io/distroless/nodejs:16
COPY --from=build-env /app /app
WORKDIR /app
CMD ["index.js"]

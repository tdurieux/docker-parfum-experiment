# Looking for information on environment variables?
# We don't declare them here — take a look at our docs.
# https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/configuration.md

FROM nginx:1.21.6-alpine

RUN apk update && apk add --no-cache "nodejs>=14.17.6-r0"

LABEL maintainer="fehguy"

ENV API_KEY "**None**"
ENV SWAGGER_JSON "/app/swagger.json"
ENV PORT 8080
ENV BASE_URL ""
ENV SWAGGER_JSON_URL ""

COPY --chown=nginx:nginx --chmod=0666 ./docker/nginx.conf ./docker/cors.conf /etc/nginx/

# copy swagger files to the `/js` folder
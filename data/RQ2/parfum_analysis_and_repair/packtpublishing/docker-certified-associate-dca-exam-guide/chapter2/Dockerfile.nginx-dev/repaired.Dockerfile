FROM nginx:alpine
RUN apk update -q
RUN apk add --no-cache \
curl \
httpie
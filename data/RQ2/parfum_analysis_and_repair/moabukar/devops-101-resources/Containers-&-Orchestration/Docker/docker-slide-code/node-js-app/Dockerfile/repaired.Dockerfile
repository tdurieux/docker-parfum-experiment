FROM alpine
LABEL maintainer="ali@gmail.com"
RUN apk add --no-cache --update nodejs npm
RUN apk add --no-cache --update npm
COPY . /src
WORKDIR /src
ENV CREATEDBY="Ali"
EXPOSE 8080
ENTRYPOINT ["node", "./app.js"]

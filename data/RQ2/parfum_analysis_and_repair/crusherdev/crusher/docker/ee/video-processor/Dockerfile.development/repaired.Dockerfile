FROM node:lts-alpine3.12

MAINTAINER Utkarsh Dixit "utkarshdix02@gmail.com"

RUN apk add --no-cache bash
RUN apk add --no-cache mysql-client
RUN apk add --no-cache git

VOLUME ["/video-processor"]

WORKDIR /video-processor

ENTRYPOINT ["npm"]
CMD ["run", "-s", "start"]
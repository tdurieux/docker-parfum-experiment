FROM alpine

# this is comment
LABEL tag="1.0.0"

RUN apk update && apk upgrade && apk add --no-cache bash

RUN ["mkdir", "/test"]



EXPOSE 80


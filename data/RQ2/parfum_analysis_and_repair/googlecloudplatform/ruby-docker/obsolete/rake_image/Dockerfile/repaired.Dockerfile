FROM gcr.io/cloud-builders/docker

RUN apk update && apk upgrade && apk --update --no-cache add ruby-rake ruby-minitest curl

ENTRYPOINT 'rake'

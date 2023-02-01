FROM alpine:latest


## RUN -- runs during image building
## CMD -- runs when initializing a container from an image

RUN apk --update --no-cache add openjdk8-jre \
    && apk add --no-cache wget \
    && apk add --no-cache --update nodejs nodejs-npm \
    && apk -Uuv --no-cache add groff less python py-pip \
    && pip install --no-cache-dir awscli


RUN npm install serverless -g \
    && mkdir /tmp/serverless && npm cache clean --force;

WORKDIR /tmp/serverless
COPY run_sls.sh .

RUN chmod +x run_sls.sh

### runs a sls hello-world from a template
ENTRYPOINT [ "./run_sls.sh"]

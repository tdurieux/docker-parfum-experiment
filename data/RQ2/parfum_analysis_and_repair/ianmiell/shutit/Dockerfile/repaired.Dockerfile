FROM alpine

# ShutIt in a container.

RUN apk add --no-cache --update py-pip
RUN pip install --no-cache-dir shutit

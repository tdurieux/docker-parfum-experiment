FROM alpine:latest

RUN apk -U --no-cache add ca-certificates python py-yaml py-pip
RUN pip install --no-cache-dir mock

ADD src/ /src/
ADD lighter /

# Run unit tests
ADD test /
RUN /test

# Expect config directory tree to be mounted into /site
VOLUME /site
WORKDIR /site

ENTRYPOINT ["/lighter"]

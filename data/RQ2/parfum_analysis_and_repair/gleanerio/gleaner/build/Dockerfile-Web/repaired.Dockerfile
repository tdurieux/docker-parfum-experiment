# Start from scratch image and add in a precompiled binary
# CGO_ENABLED=0 env  go build .
# docker build  --tag="opencoredata/ocdweb:0.9.4"  .
# docker run -d -p 9900:9900  opencoredata/ocdweb:0.9.4
FROM alpine
#FROM scratch

#RUN apk add py-urllib3 openssl certbot curl --no-cache \
RUN apk add openssl certbot curl --no-cache \
    --repository http://dl-3.alpinelinux.org/alpine/v3.7/community/ \
    --repository http://dl-3.alpinelinux.org/alpine/v3.7/main/ \
    && rm -rf /var/cache/apk/*

# Add in the static elements (could also mount these from local filesystem)
RUN mkdir /gleaner
RUN mkdir /static
RUN mkdir /gleaner/config
ADD ./cmd/glweb/glweb /gleaner/
ADD ./secret/glweb/geodexv2.yml /config.yml
ADD ./secret/glweb/jsonldcontext.jsonld /
COPY ./static /static/

# ADD ../web/static  /static   # Replace with -v mounting the /web/static directory
# static is in the .dockerignore..  so an emptry dir is made unless static is removed
# from the ignore file... we mount the volume via compose from the local FS

EXPOSE 9900

# Add our binary
ENTRYPOINT ["/gleaner/glweb", "-cfg", "config"]

# CMD append
#CMD ["appendToEtnryPoint"]
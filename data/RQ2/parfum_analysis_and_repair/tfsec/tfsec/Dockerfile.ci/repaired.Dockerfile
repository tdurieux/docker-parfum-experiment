FROM alpine:latest

# install git
RUN apk add --no-cache git

COPY tfsec /usr/bin/tfsec

## use a non-privileged user
RUN adduser -D tfsec
USER tfsec

# as we are not specifying an entrypoint, this is the default executed command
# that you could override
CMD [ "tfsec", "--help" ]
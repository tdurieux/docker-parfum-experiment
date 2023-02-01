FROM alpine:3.10

RUN apk add --no-cache jq curl

# RUN mkdir /scripts

# WORKDIR /scripts

# COPY ./init.sh .

# CMD ./init.sh
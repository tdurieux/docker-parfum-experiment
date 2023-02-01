FROM docker:20.10.12

# Install dependencies.
RUN apk update && apk add --no-cache bash jq

WORKDIR /home/dblab
COPY ./bin/dblab ./bin/dblab
CMD ./bin/dblab
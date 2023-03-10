# Example overview:
# - in case you want to parametrise something in the ENTRYPOINT (in this case script), you can use ENV vars
# - ENV keyword defines default value while that value can be overriden when running the container
# - in this example, if -v specified when running container, it demonstrates how to persist output data from the script across multiple container runs
FROM alpine:3.12.0

# Install system deps
RUN apk update \
    && apk add --no-cache jq curl busybox-extras

# Do setup for running script
WORKDIR /myscripts
COPY ./example_2.sh .
RUN chmod +x example_2.sh

# Run script
ENV name=Bakir
ENTRYPOINT ["sh", "-c", "./example_2.sh -n $name"]
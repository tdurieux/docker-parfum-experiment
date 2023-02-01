# Example overview:
# - starting example which shows anatomy of simple Dockerfile
# - purposely uses larger distro (ubuntu) and incorrect ordering of some docker commands which will be improved in Dockerfile.v2
FROM ubuntu:18.04

# Do setup for running script
WORKDIR /myscripts
COPY ./example_1.sh .
RUN chmod +x example_1.sh

# Install system deps
RUN apt update \
    && apt install --no-install-recommends -y jq telnet && rm -rf /var/lib/apt/lists/*;

# Run script
ENTRYPOINT ["./example_1.sh", "-n", "Test"]
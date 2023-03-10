# This docker container is used from Jenkins in order to run the integation
# tests such that they do not conflict with other things running on the
# same server.

# The container is built and pushed to Docker hub as follows:
#   commit=`git rev-parse --short HEAD`
#   docker build -f Dockerfile-int -t dedis/cothority-integration-tester:$commit .

FROM golang:1.15
RUN apt update && apt install -y --no-install-recommends pcregrep && apt clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /cothority
CMD ["./integration_test.sh" ]

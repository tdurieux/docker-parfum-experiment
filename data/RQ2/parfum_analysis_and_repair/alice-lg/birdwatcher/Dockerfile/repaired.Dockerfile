#
# Birdwatcher - Your friendly alice looking glass data source
#

FROM golang:1.13 AS app

WORKDIR /src/birdwatcher
ADD vendor .
ADD go.mod .
ADD go.sum .
RUN go mod download

# Add sourcecode
ADD . .

# Build birdwatcher
RUN make

# Add birdwatcher to bird
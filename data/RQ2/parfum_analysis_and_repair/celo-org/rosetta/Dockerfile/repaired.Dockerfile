# USAGE INSTRUCTIONS:
#
# Docker Container Label: gcr.io/celo-testnet/rosetta
#
# Local Build For testing: 
#    docker build -t gcr.io/celo-testnet/rosetta:$USER .
#
# Run rosetta
#    docker rm rosetta    # Removes rosetta named container
#    docker run --name rosetta gcr.io/celo-testnet/rosetta:$USER
#    # or to create & delete
#    docker run -rm gcr.io/celo-testnet/rosetta:$USER
#
# Build & Deploy:
#    export COMMIT_SHA=$(git rev-parse HEAD)
#    docker build --build-arg COMMIT_SHA=$COMMIT_SHA -t gcr.io/celo-testnet/rosetta:$COMMIT_SHA .
#    docker push gcr.io/celo-testnet/rosetta:$COMMIT_SHA


#---------------------------------------------------------------------
# Stage 1: Build Rosetta
# Outputs: binary @ /rosetta/rosetta 
#---------------------------------------------------------------------
FROM golang:1.17-alpine as builder
WORKDIR /rosetta
RUN apk add --no-cache make gcc musl-dev linux-headers git

# Downnload dependencies & cache them in docker layer
COPY go.mod .
COPY go.sum .
RUN go mod download

# Build project
#  (this saves to redownload everything when go.mod/sum didn't change)
COPY . .
RUN go build --tags musl -o rosetta .


#---------------------------------------------------------------------
# Stage 2: Build Final container
# Integrates celo-blockchain & rosetta builds into a single container
# Outputs: rosetta & geth binaries on /usr/loca/bin
#---------------------------------------------------------------------
# geth mainnet (1.5.1)
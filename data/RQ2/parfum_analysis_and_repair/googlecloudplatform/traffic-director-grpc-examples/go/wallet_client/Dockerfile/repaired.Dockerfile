# Dockerfile for building the wallet client. To build the image, run the
# following command from the traffic-director-grpc-examples directory:
# docker build -t <TAG> -f go/wallet_client/Dockerfile .

# Use a non-alpine image as the base image so that we have some basic tools like
# bash available when we ssh into the pod to execute client commands.
FROM golang:1.16 as build

# Make a traffic-director-grpc-examples directory and copy the repo into it.
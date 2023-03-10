# syntax=docker/dockerfile:1.2

# NOTE: because migrations come from outside the `front_api` directory,
#       we build this image from project root, symlinking this file to
#       Dockerfile.front_api

FROM golang:1.16.5-buster as builder

WORKDIR /horahora/front_api

# build binary
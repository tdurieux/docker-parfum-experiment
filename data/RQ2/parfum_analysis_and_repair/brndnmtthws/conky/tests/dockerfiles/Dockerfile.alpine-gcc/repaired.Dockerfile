ARG IMAGE=registry.gitlab.com/brndnmtthws-oss/conky
FROM ${IMAGE}/builder/alpine-base:latest

RUN apk add --no-cache \
  g++ \
  gcc
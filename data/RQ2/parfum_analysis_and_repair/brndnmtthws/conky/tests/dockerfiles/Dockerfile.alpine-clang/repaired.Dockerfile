ARG IMAGE=registry.gitlab.com/brndnmtthws-oss/conky
FROM ${IMAGE}/builder/arch-base:latest

RUN apk add --no-cache \
  clang
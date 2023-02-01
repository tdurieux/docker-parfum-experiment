## Build Arguments ##
#####################
## Set the python image tag to use as the base image. 
# See https://hub.docker.com/_/python?tab=tags for a list of valid tags.
# Set  default below to desired Python version.
ARG PYTHON_TAG=3.9-alpine
##

## Set the UID/GID that sopel will run and make files/folders as.
# For security, these values are set past the upper limit of named users in most
# linux environments. `chown` any volume mounts to the IDs specified here, or 
# change to match your GID (and UID if desired) if you think its okay ¯\_(ツ)_/¯
ARG SOPEL_GID=100000
ARG SOPEL_UID=100000
##

## Set the repository used to pull the sopel source
# Set Docker build-arg SOPEL_REPO with private fork, or change default below 
# as desired. Any valid Git URL is acceptable.
ARG SOPEL_REPO=https://github.com/sopel-irc/sopel.git
##

## Set the specific branch/commit for the source
# This can be a branch name, release/tag, or even specific commit hash.
# Set Docker build-arg SOPEL_BRANCH, or replace the default value below.
ARG SOPEL_BRANCH=v7.1.9
##

## Do not modify below this !! ##
#################################

#####
### STAGE 1: Pull latest source
#####
FROM alpine:latest AS git-fetch

ARG SOPEL_REPO
ARG SOPEL_BRANCH

RUN set -ex \
  && apk add --no-cache --virtual .git \
    git \
  && git clone \
    --depth 1 --branch ${SOPEL_BRANCH} \
    ${SOPEL_REPO} /sopel-src \
  && apk del \
    .git
#####
#####

#####
### STAGE 2: Install Sopel
#####
FROM python:${PYTHON_TAG}
# Pre-set ARGs
ARG SOPEL_BRANCH
# Injected ARGs
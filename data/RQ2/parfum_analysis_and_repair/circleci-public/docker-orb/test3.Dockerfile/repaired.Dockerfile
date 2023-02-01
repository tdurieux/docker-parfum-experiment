# vim:set ft=dockerfile:
#
# The Ubuntu-based CircleCI Docker Image. Only use Ubuntu Long-Term Support
# (LTS) releases.

FROM ubuntu:18.04

LABEL maintainer="CircleCI <support@circleci.com>"

ARG COMMIT_HASH

# Change default shell from Dash to Bash
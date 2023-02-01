# This file was auto-generated, do not edit it directly.
# Instead run bin/update_build_scripts from
# https://github.com/sharelatex/sharelatex-dev-environment

FROM node:12.22.3 as base

WORKDIR /app

FROM base as app

#wildcard as some files may not be in all repos
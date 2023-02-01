# Build:
#   docker build -t asmichi/node-azuredevops:14-alpine .
#
# See https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases?view=azure-devops#non-glibc-based-containers
FROM node:14-alpine

RUN apk add --no-cache --virtual .pipeline-deps readline linux-pam \
  && apk add --no-cache \
    # Azure Pipeline depndencies
    bash \
    sudo \
    shadow \
    # .NET Core dependencies
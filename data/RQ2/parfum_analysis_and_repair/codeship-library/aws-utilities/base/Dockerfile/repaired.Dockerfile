FROM python:3.9-alpine
LABEL maintainer='Codeship Inc., <maintainers@codeship.com>'

# which version of the AWS CLI to install.
# https://pypi.python.org/pypi/awscli
ARG AWS_CLI_VERSION="1.20.53"

ENV PIP_DISABLE_PIP_VERSION_CHECK=true

RUN \
  pip install --no-cache-dir awscli==${AWS_CLI_VERSION} && \
  mkdir -p "${HOME}/.aws"

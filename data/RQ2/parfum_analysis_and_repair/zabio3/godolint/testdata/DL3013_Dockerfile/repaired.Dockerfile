FROM python:3.4
RUN pip install --no-cache-dir django
RUN pip install --no-cache-dir https://github.com/Banno/carbon/tarball/0.9.x-fix-events-callback

ARG YAML_LINT_VERSION=v1.26.3

RUN pip install --no-cache-dir yamllint=="${YAML_LINT_VERSION:-v1.26.3}"

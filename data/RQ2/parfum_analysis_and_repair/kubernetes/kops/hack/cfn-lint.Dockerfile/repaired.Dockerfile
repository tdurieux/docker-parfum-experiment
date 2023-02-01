FROM python:3.9-alpine
ARG CFNLINT_VERSION
RUN pip install --no-cache-dir "cfn-lint==${CFNLINT_VERSION}" pydot
ENTRYPOINT ["cfn-lint"]
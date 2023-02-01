FROM python:3.8-alpine

RUN pip install --no-cache-dir cfn-lint
RUN pip install --no-cache-dir pydot

ENTRYPOINT ["cfn-lint"]
CMD ["--help"]

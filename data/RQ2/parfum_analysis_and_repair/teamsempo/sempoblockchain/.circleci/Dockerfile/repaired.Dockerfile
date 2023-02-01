FROM circleci/python:3.6-node

RUN pip install --no-cache-dir --user awscli && pip install --no-cache-dir --user awsebcli

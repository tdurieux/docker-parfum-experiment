FROM python:3.8.0
LABEL maintainer="Alexander.Richardson@cl.cam.ac.uk"

RUN pip install --no-cache-dir pytest

# setting Git username and email for workaround of
# https://github.com/jenkinsci/docker/issues/519
ENV GIT_COMMITTER_NAME cheribuild
ENV GIT_COMMITTER_EMAIL cheribuild@cl.cam.ac.uk
FROM python:3

LABEL maintainer="Guillaume Core (fridim) <gucore@redhat.com>"

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir ansible awscli
RUN pip install --no-cache-dir boto boto3

USER ${USER_UID}
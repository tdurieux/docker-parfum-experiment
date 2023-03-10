FROM python:3.7-alpine3.7

# NOTE: this was taken and adapted from https://github.com/JoshuaRLi/alpine-python3-pip/blob/master/Dockerfile

RUN apk add --no-cache --update \
    jq \
    && pip3 install --no-cache-dir requests

COPY ./dtcli.py /dtcli/dtcli.py

CMD ["bash"]

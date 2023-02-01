FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y curl fuse krb5-user python-is-python3 python3-pip &&\
    rm -rf /var/lib/apt/lists/*

RUN python -m pip install azureml-core>=1.40.0 azureml-dataprep

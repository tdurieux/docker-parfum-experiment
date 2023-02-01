FROM ubuntu:latest

RUN apt-get update && apt-get --yes --no-install-recommends install python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes upgrade


RUN mkdir -p /opt/cv19index/
COPY sagemaker/docker-requirements.txt /opt/cv19index/docker-requirements.txt
# Provides a cache stage with pandas and xgboost installed
RUN pip3 install --no-cache-dir -r /opt/cv19index/docker-requirements.txt

COPY . /opt/cv19index/
# This exposes a serve command for sagemaker
RUN pip3 install --no-cache-dir /opt/cv19index/

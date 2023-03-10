#################
# Ubuntu Image for BOINC-MIDAS usage
#
# Specifically designed to run BOINC jobs from a set of input files
# Contains bash, curl, wget, tar, python3, pip3 as default
#################


FROM ubuntu:16.04

COPY Mov_Specific.py /Mov_Specific.py


RUN mkdir -p /root/shared/results &&\
    apt-get update && apt-get install --no-install-recommends curl wget tar unzip python3 python3-pip python3-tk cmake -y && \
    pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /work

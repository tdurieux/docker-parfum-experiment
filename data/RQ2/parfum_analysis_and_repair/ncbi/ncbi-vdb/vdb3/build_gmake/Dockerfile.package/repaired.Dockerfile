FROM ubuntu:latest
LABEL maintainer="<sra-tools@ncbi.nlm.nih.gov>"
RUN mkdir -p /ncbi-vdb3
WORKDIR /ncbi-vdb3
COPY . /ncbi-vdb3
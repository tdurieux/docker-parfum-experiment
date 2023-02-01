#ubuntu 18.04 is used in ADO build pipeline, by 12/15/2021
#FROM ubuntu:18.04 AS base-layer
#COPY installNode14Repo.sh /tmp/installNode14Repo.sh
#RUN sh /tmp/installNode14Repo.sh && apt-get update && apt-get install nodejs=14.18.2-1nodesource1 -y
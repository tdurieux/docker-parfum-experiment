FROM registry.centos.org/centos/centos:centos7 AS base
RUN touch -t 201701261659.13 /1
ENV LOCAL=/1

FROM base
RUN find $LOCAL
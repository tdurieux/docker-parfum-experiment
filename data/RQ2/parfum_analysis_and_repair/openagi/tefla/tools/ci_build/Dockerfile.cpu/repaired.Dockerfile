# Copyright 2018 The Tefla Authors. All Rights Reserved.
FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

LABEL maintainer="Ishant Mrinal Haloi <mrinalhaloi11@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND teletype
ENV MPLBACKEND Agg
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tefla

# Copy and run the install scripts.
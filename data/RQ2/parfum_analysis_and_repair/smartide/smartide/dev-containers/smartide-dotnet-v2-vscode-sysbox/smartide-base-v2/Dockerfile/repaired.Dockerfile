#################################################
# SmartIDE Developer Container Image
# Licensed under GPL v3.0
# Copyright (C) leansoftX.com
#################################################

FROM ubuntu:bionic


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ Asia/Shanghai
#git中文乱码问题
ENV LESSCHARSET=utf-8

# sshd
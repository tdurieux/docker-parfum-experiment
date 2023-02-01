# Author: Bruno Borges <bruno.borges@oracle.com>
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
# Copyright (c) 2015 Oracle and/or its affiliates. All rights reserved.
# 
FROM oraclelinux:7-slim

MAINTAINER Bruno Borges <bruno.borges@oracle.com>

RUN yum -y install java-1.8.0-openjdk-devel && rm -rf /var/cache/yum

ENV JAVA_HOME /usr/lib/jvm/java-openjdk

CMD ["java", "-version"]

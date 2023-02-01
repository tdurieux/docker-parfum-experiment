# KaveToolbox 3.7-Beta on centos 7
FROM kave/kavetoolbox:3.7-Beta.c7.node
MAINTAINER KAVE <kave@kpmg.com>
RUN yum clean all

# hack linux version detection for windows builds (docker inconsistent!)
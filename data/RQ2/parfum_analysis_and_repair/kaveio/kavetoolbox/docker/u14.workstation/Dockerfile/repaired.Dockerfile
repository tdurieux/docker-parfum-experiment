# KaveToolbox 3.7-Beta on ubuntu 14
FROM kave/kavetoolbox:3.7-Beta.u14.node
MAINTAINER KAVE <kave@kpmg.com>
RUN apt-get update

# hack linux version detection for windows builds (docker inconsistent!)
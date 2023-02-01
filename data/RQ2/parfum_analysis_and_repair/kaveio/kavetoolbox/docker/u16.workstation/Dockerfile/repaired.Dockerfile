# KaveToolbox 3.7-Beta on ubuntu 16
FROM kave/kavetoolbox:3.7-Beta.u16.node
MAINTAINER KAVE <kave@kpmg.com>
RUN apt-get update

# hack linux version detection for windows builds (docker inconsistent!)
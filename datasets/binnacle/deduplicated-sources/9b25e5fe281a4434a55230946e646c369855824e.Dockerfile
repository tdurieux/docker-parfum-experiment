FROM ubuntu:19.04
ADD . /paa_build
RUN bash /paa_build/install.sh

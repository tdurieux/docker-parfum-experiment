FROM ubuntu:20.04
ADD . /paa_build
RUN bash /paa_build/install.sh
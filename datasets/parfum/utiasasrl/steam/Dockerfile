FROM ubuntu:20.04

CMD ["/bin/bash"]

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -q -y curl gnupg2 lsb-release build-essential cmake
RUN apt install -q -y libeigen3-dev libomp-dev
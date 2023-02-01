FROM ubuntu:18.04
LABEL maintainer="Ben Aaron <benaagoldberg@gmail.com>"
RUN apt-get update
RUN apt-get install -y curl gcc libgtk-3-dev qtbase5-dev qtdeclarative5-dev qt5-default
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
ENV PATH="/root/.cargo/bin:${PATH}"
WORKDIR /root/build
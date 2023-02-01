FROM ubuntu:20.04

CMD ["/bin/bash"]

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install --no-install-recommends -q -y curl gnupg2 lsb-release build-essential cmake && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -q -y libeigen3-dev libomp-dev && rm -rf /var/lib/apt/lists/*;
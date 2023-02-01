FROM ubuntu:17.10

ENV DEBIAN_FRONTEND noninteractive

#install prerequisits
RUN apt-get update && \
    apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

RUN sudo apt update && sudo apt -y --no-install-recommends install ocl-icd-opencl-dev && rm -rf /var/lib/apt/lists/*;

RUN sudo apt -y --no-install-recommends install opencl-headers && sudo apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;

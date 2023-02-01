FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y wget make cmake git p7zip-full g++ qt5-default && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/dsiganos/nano-workspace.git
RUN make -C nano-workspace git.clone.done
RUN make -C nano-workspace boost
RUN make -C nano-workspace

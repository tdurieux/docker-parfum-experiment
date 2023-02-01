FROM ubuntu:18.04

#
# Install anything needed in the system
#
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git python3-minimal python3-pip && rm -rf /var/lib/apt/lists/*;

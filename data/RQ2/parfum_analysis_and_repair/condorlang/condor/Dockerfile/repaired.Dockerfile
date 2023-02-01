FROM ubuntu:latest

# Create a well-known place for all this to happen
RUN mkdir /Condor
WORKDIR /Condor

# Update/upgrade all packages
RUN apt-get update && apt-get install --no-install-recommends -y build-essential git python cmake make gcc-multilib g++-multilib clang curl jq gdb && rm -rf /var/lib/apt/lists/*; # Install Git, Python, make and build tools


ADD ./ /Condor
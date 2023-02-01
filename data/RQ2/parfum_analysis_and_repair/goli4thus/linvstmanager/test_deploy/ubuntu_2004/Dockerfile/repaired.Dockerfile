# Set ubuntu as base image
FROM ubuntu:20.04

# Install dependencies
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get install --no-install-recommends -y cmake gcc g++ git qt5-default && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/build

CMD ["bash"]


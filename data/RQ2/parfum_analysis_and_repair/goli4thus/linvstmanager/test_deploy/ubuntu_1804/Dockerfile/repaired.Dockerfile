# Set ubuntu as base image
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y cmake gcc g++ git qt5-default && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/developer/build

CMD ["bash"]


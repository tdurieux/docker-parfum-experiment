FROM ubuntu:latest
RUN apt update && apt-get install --no-install-recommends -y gcc g++ make cmake git libboost-dev libopenmpi-dev libhdf5-openmpi-dev doxygen && rm -rf /var/lib/apt/lists/*;
CMD ["bash"]

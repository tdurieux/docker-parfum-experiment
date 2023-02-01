FROM ubuntu:22.04

WORKDIR /data
RUN apt-get update
RUN apt-get install --no-install-recommends -y libopenmpi-dev openmpi-bin libhdf5-openmpi-dev git pkg-config gcc libaio-dev libpnetcdf-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

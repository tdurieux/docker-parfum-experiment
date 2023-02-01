# Install environment & dependencies for rack

FROM ubuntu:18.04
RUN apt-get update && apt-get -y --no-install-recommends install g++ git make libproj-dev libhdf5-dev libtiff-dev libgeotiff-dev libpng-dev && rm -rf /var/lib/apt/lists/*;

# Prepare for rack build
RUN git clone https://github.com/fmidev/rack.git
COPY install-rack.cnf rack/rack

# Build: after this the binary is in rack/Release/rack and also copied to /usr/local/bin
RUN cd rack/rack && ./build.sh


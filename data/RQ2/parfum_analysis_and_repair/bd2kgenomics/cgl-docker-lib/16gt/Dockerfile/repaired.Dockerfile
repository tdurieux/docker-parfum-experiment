FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential zlib1g-dev git && rm -rf /var/lib/apt/lists/*;

# Make a working directory
RUN mkdir /opt/cgl-docker-lib

# Clone 16gt
WORKDIR /opt/cgl-docker-lib
RUN git clone https://github.com/aquaskyline/16GT.git

# Compile
WORKDIR /opt/cgl-docker-lib/16GT
RUN git checkout 4d894ad188674494dd7f05fc68b0aed90dcf5d1e
RUN make
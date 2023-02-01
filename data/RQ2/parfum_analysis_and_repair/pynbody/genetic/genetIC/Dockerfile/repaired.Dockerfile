FROM ubuntu:20.04
COPY ./ /genetIC

RUN apt-get update && apt-get install --no-install-recommends -y g++-9 libgsl-dev libfftw3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir numpy pynbody
RUN cd /genetIC && make clean && make

ENTRYPOINT ["/genetIC/genetIC"]

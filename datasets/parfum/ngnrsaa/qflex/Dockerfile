# Base OS
FROM ngnrsaa/cirq-alpine:latest

# Install baseline
RUN apk update
RUN apk add git g++ make openblas-dev git autoconf automake python3-dev py3-pybind11 py3-packaging py3-pytest py3-docopt

# Copy relevant files to create Makefile's
COPY ./.git/ /qflex/.git/
COPY ./configure.ac /qflex/
COPY ./Makefile.in /qflex/
COPY ./src/main.cpp /qflex/src/
COPY ./src/Makefile.in /qflex/src/
COPY ./tests/python/Makefile.in /qflex/tests/python/
COPY ./tests/src/Makefile.in /qflex/tests/src/
COPY ./config /qflex/config/

WORKDIR /qflex/

# Create Makefile's
RUN autoreconf -i && autoconf && ./configure --disable-all_checks

# Copy python modules
COPY ./qflexcirq/ /qflex/qflexcirq/

# Copy src files for qflex
COPY ./src/ /qflex/src/

# Arguments from docker-compose
ARG OMP_NUM_THREADS

# Compile qflex
RUN make -j${OMP_NUM_THREADS:-8}

ENTRYPOINT ["/qflex/src/qflex.x"]

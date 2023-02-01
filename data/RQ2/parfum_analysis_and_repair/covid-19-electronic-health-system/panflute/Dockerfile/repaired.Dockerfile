FROM ubuntu:18.04

WORKDIR panFLUte/
COPY board .

RUN apt-get update && apt-get install --no-install-recommends -y \
    make \
    gcc-avr \
    binutils-avr \
    avr-libc \
    avrdude \
    nano \
    vim && rm -rf /var/lib/apt/lists/*;

RUN make

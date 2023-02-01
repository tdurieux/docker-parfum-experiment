FROM rust:1.52.0

# RUN apk update && apk add rust cargo yasm cmake
RUN apt update -y && apt install --no-install-recommends -y yasm cmake python3-pip && rm -rf /var/lib/apt/lists/*;
RUN alias python=python3

RUN pip3 install --no-cache-dir --upgrade pip

WORKDIR /srv/app/

# base for python
COPY ./src/program_generator/requirements.txt /srv/app/src/program_generator/requirements.txt
RUN pip3 install --no-cache-dir -r src/program_generator/requirements.txt

# get our files for openethereum
# NOTE: we don't do `RUN git submodule update --init --recursive`. You should do this in the host
COPY ./src/instrumentation_measurement/openethereum /srv/app/src/instrumentation_measurement/openethereum
WORKDIR /srv/app/src/instrumentation_measurement/openethereum/bin/evmbin/

RUN cargo build --release

# get the remainder of our files
COPY ./src/ /srv/app/src/

WORKDIR /srv/app/

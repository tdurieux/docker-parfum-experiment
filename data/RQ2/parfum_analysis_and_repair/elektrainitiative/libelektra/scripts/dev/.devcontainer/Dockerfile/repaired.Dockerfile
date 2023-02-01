FROM debian:bullseye
RUN apt-get update && apt-get install --no-install-recommends cmake git build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/ElektraInitiative/libelektra.git
WORKDIR /libelektra
RUN mkdir build
WORKDIR /libelektra/build
RUN cmake ..
RUN make install

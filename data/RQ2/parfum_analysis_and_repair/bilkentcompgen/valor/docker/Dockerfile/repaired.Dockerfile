FROM ubuntu:16.04

RUN apt-get update -y --fix-missing && apt-get install --no-install-recommends git make gcc zlib1g-dev -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /valor
RUN mkdir /input
RUN mkdir /output
WORKDIR /valor

RUN git clone https://github.com/BilkentCompGen/valor.git /valor --recursive
RUN make libs && make

ENV PATH="/valor:${PATH}"
VOLUME /input
VOLUME /output
ENTRYPOINT ["/valor/valor"]

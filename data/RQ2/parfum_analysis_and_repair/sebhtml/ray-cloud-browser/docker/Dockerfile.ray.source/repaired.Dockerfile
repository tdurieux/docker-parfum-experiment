FROM ray-covid-sequences AS seq
FROM debian:stretch
RUN apt-get update && apt-get install --no-install-recommends -y build-essential openmpi-bin libopenmpi-dev git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/sebhtml/ray.git
RUN git clone https://github.com/sebhtml/RayPlatform.git
WORKDIR ray
RUN make
WORKDIR /
COPY --from=seq /wuhan.fasta /wuhan.fasta
COPY --from=seq /NY.fasta /NY.fasta
RUN /ray/Ray -s wuhan.fasta -s NY.fasta -o Graphs -k 31 -graph-only -write-kmers -use-minimum-seed-coverage 1 -bloom-filter-bits 0

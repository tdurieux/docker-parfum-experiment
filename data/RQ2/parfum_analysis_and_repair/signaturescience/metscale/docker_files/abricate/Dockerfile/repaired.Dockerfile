FROM ubuntu:16.04
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y emboss bioperl ncbi-blast+ gzip unzip \
  libjson-perl libtext-csv-perl libfile-slurp-perl liblwp-protocol-https-perl libwww-perl git && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


RUN git clone https://github.com/tseemann/abricate.git
RUN ./abricate/bin/abricate --check
RUN ./abricate/bin/abricate --setupdb
ENTRYPOINT abricate/bin/abricate
CMD abricate/bin/abricate


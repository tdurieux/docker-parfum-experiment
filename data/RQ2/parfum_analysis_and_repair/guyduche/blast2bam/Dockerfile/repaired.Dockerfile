FROM ubuntu:20.04

LABEL author="Aurelien Guy-Duche"

RUN apt update && apt install --no-install-recommends -y make gcc libxml2-dev xsltproc zlib1g-dev && rm -rf /var/lib/apt/lists/*;

ADD src /blast2bam

RUN cd blast2bam && make

WORKDIR /data

ENTRYPOINT ["blast2bam"]

CMD ["--help"]

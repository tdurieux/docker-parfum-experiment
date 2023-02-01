FROM nextgenusfs/base-amptk
MAINTAINER Jon Palmer <nextgenusfs@gmail.com>

RUN mkdir /amptk

COPY usearch9.2.64_i86linux32 /amptk/usearch9

COPY usearch10.0.240_i86linux32 /amptk/usearch10

RUN chmod +x /amptk/usearch9 && \
  chmod +x /amptk/usearch10 && \
  amptk install -i ITS LSU 16S COI --force

WORKDIR /work

ENTRYPOINT source activate && /bin/bash

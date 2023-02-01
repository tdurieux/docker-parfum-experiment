FROM golang:latest as builder

WORKDIR /opt/build
ADD backend .
RUN go build -o mmseqs-web

ADD https://mmseqs.com/latest/mmseqs-linux-avx2.tar.gz  .
ADD https://mmseqs.com/latest/mmseqs-linux-sse41.tar.gz .
ADD https://mmseqs.com/latest/mmseqs-linux-sse2.tar.gz  .

ADD https://mmseqs.com/foldseek/foldseek-linux-avx2.tar.gz  .
ADD https://mmseqs.com/foldseek/foldseek-linux-sse41.tar.gz .
ADD https://mmseqs.com/foldseek/foldseek-linux-sse2.tar.gz  .


RUN mkdir binaries; \
    for i in mmseqs foldseek; do \
      for j in sse2 sse41 avx2; do \
        cat ${i}-linux-${j}.tar.gz | tar -xzvf- ${i}/bin/${i}; \
        mv ${i}/bin/${i} binaries/${i}_${j}; \
      done; \
    done;

ADD https://raw.githubusercontent.com/soedinglab/MMseqs2/678c82ac44f1178bf9a3d49bfab9d7eed3f17fbc/util/mmseqs_wrapper.sh binaries/mmseqs
RUN sed 's|mmseqs|foldseek|g' binaries/mmseqs > binaries/foldseek
RUN chmod -R +x binaries

FROM debian:stable-slim
LABEL maintainer="Milot Mirdita <milot@mirdita.de>"

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates wget && rm -rf /var/lib/apt/lists/*
COPY --from=builder  /opt/build/mmseqs-web /opt/build/binaries/* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/mmseqs-web"]

FROM ubuntu:17.10 as hmmerbuild

ARG VERSION

USER root
WORKDIR /root/


RUN apt-get -y -m update && apt-get install --no-install-recommends -y build-essential wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2.tar.gz
RUN tar xvf hmmer-3.1b2.tar.gz && rm hmmer-3.1b2.tar.gz


WORKDIR /root/hmmer-3.1b2
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-portable-binary --prefix=/hmmer && make && make install
WORKDIR easel
RUN make install

FROM ubuntu:17.10

COPY VERSION .

USER root
COPY --from=hmmerbuild /hmmer/bin /hmmer/bin

WORKDIR /hmmer/hmmerdb
ENV HMMERDB=/hmmer/hmmerdb
ENV PATH="/hmmer/bin:${PATH}"

CMD ["/bin/bash"]


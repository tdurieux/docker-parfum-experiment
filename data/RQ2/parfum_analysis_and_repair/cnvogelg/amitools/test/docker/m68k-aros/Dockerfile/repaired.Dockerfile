FROM debian:10 AS builder

RUN apt-get update && \
  apt-get install --no-install-recommends -y build-essential netpbm git automake make bison flex \
    python3 python3-mako libpng-dev wget texinfo && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/
RUN git clone https://github.com/aros-development-team/AROS.git && \
  cd AROS && git submodule init && git submodule update
RUN mv AROS /opt/m68k-aros
RUN cd opt/m68k-aros && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --target=amiga-m68k && make

FROM debian:10

RUN apt-get update && \
  apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

ENV PATH=/opt/m68k-aros/bin/linux-x86_64/tools/crosstools/:$PATH

COPY --from=builder /opt/m68k-aros/bin/linux-x86_64/tools/crosstools/ /opt/m68k-aros/bin/linux-x86_64/tools/crosstools/
COPY --from=builder /opt/m68k-aros/bin/amiga-m68k/AROS/Developer/ /opt/m68k-aros/bin/amiga-m68k/AROS/Developer/

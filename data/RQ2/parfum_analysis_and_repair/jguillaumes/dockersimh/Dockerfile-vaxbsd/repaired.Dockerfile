ARG version="3.0-debian"
FROM jguillaumes/simh-allsims:$version

LABEL version="$version"
LABEL description="vax (8600) SIMH simulator with BSD 4.3 image"
LABEL maintainer="Jordi Guillaumes Pons <jguillaumes@gmail.com>"


ENV PATH /simh-bin:$PATH
ENV SIMULATOR vax780
ENV SIMDIR vaxbsd
ENV OSIMAGE  RA81.000.gz
ENV OSIMAGE2 RA81VHD.001.gz

VOLUME /machines
WORKDIR /machines
RUN cp /simh-bin/$SIMULATOR /machines/$SIMULATOR && \
    rm -r /simh-bin/* && \
    mv /machines/$SIMULATOR /simh-bin && \
    mkdir /image

EXPOSE 2323-2324

WORKDIR /image
COPY /$SIMDIR/$OSIMAGE       /image/
COPY /$SIMDIR/*.txt          /image/
COPY /$SIMDIR/$SIMULATOR.ini /image/
COPY /$SIMDIR/startup.sh     /startup.sh
COPY /$SIMDIR/original-content /machines

COPY /$SIMDIR/$OSIMAGE2 /image/
COPY /$SIMDIR/boot43    /image/

WORKDIR /machines

ENTRYPOINT ["/startup.sh"]
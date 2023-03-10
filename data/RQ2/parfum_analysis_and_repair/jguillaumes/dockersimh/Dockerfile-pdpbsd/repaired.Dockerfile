ARG version="3.0-debian"
FROM jguillaumes/simh-allsims:$version

LABEL version="$version"
LABEL description="pdp11 SIMH simulator with BSD image"
LABEL maintainer="Jordi Guillaumes Pons <jguillaumes@gmail.com>"


ENV PATH /simh-bin:$PATH
ENV SIMULATOR pdp11
ENV SIMDIR pdpbsd
ENV OSIMAGE  RA81.000.gz

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

WORKDIR /machines

ENTRYPOINT ["/startup.sh"]
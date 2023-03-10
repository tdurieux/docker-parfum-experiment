ARG version="3.0-debian"
FROM jguillaumes/simh-allsims:$version

LABEL version="$version"
LABEL description="pdp8 SIMH simulator with OS/8 image"
LABEL maintainer="Jordi Guillaumes Pons <jguillaumes@gmail.com>"

ENV PATH /simh-bin:$PATH
ENV SIMULATOR pdp8
ENV SIMDIR pdp8
ENV OSIMAGE1  RK0.img.gz
ENV OSIMAGE2  RK1.img.gz

VOLUME /machines
WORKDIR /machines
RUN cp /simh-bin/$SIMULATOR /machines/$SIMULATOR && \
    rm -r /simh-bin/* && \
    mv /machines/$SIMULATOR /simh-bin && \
    mkdir /image

EXPOSE 2324

WORKDIR /image
COPY /$SIMDIR/$OSIMAGE1      /image/
COPY /$SIMDIR/$OSIMAGE2      /image/
COPY /$SIMDIR/*.txt          /image/
COPY /$SIMDIR/$SIMULATOR.ini /image/
COPY /$SIMDIR/startup.sh     /startup.sh
COPY /$SIMDIR/original-content /machines

WORKDIR /machines

ENTRYPOINT ["/startup.sh"]
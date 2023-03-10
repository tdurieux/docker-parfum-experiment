ARG version="3.0-debian"
FROM jguillaumes/simh-allsims:$version

LABEL version="$version"
LABEL description="vax (8600) SIMH simulator with NetBSD image"
LABEL maintainer="Jordi Guillaumes Pons <jguillaumes@gmail.com>"


ENV PATH /simh-bin:$PATH
ENV SIM vax8600
ENV SIMDIR vaxnbsd
ENV OSIMAGE  RAUSER000.vhd.gz
ENV EMPIMAGE RAUSEREMP.vhd.gz

WORKDIR /workdir
RUN cp /simh-bin/$SIM . && \
    rm -r /simh-bin/* && \
    cp $SIM /simh-bin && \
    mkdir /image

EXPOSE 2323
EXPOSE 2324

WORKDIR /image
COPY /$SIMDIR/$SIM.ini	/image/
COPY /$SIMDIR/$OSIMAGE	/image/
COPY /$SIMDIR/$EMPIMAGE	/image/
COPY /$SIMDIR/*.txt    	/image/
COPY /$SIMDIR/startup.sh /startup.sh

VOLUME /machines
WORKDIR /machines
COPY /$SIMDIR/original-content /machines/

ENTRYPOINT ["/startup.sh"]
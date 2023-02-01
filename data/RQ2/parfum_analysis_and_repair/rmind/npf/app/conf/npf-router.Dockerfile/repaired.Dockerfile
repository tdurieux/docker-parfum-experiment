##########################################################################
# NPF + DPDK builder
#
FROM npf-pkg AS npf-router-dev
WORKDIR /build
COPY . /build/npf

#
# Build the application.
#
RUN cd /build/npf/app/src && \
    make && mkdir -p /build/bin && \
    DESTDIR="/build/bin" BINDIR="" make install
RUN cp /build/npf/app/run.sh /build/bin/

##########################################################################
# Create a separate NPF-router image.
#
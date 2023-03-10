FROM napi

ENV NAPICLIENT_OPT /opt/napi
ENV NAPICLIENT_TESTDATA $NAPICLIENT_OPT/testdata
ENV NAPICLIENT_SHELLS $NAPICLIENT_OPT/bash

USER root
RUN apt-get update -y && apt-get install --no-install-recommends -y \
        libarchive-extract-perl \
        libwww-perl \
        python-pip \
        python-setuptools && rm -rf /var/lib/apt/lists/*;

ADD common $INSTALL_DIR/common
ADD napiclient $INSTALL_DIR/napiclient
ADD napiserver $INSTALL_DIR/napiserver

WORKDIR $INSTALL_DIR
RUN ./napiserver/bin/prepare_pretenders.sh
RUN ./napiclient/bin/prepare_scpmocker.pl
RUN ./napiclient/bin/prepare_python.sh

# go back to non-root user
USER napi
ENTRYPOINT []
CMD []

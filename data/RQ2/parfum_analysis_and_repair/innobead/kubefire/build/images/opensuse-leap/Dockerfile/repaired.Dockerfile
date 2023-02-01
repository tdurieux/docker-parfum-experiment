ARG RELEASE

FROM opensuse/leap:${RELEASE}

WORKDIR /workspace

COPY build/images/opensuse-leap/install.sh /workspace/bin/

RUN ./bin/install.sh
ARG TOOLCHAIN=cp2k/toolchain:latest
FROM ${TOOLCHAIN}

# author: Ole Schuett

WORKDIR /workspace

COPY ./scripts/install_basics.sh .
RUN ./install_basics.sh

COPY ./scripts/install_regtest.sh .
RUN ./install_regtest.sh local popt

COPY ./scripts/ci_entrypoint.sh ./scripts/test_farming.sh ./
CMD ["./ci_entrypoint.sh", "./test_farming.sh"]

#EOF

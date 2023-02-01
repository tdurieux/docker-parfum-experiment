ARG TOOLCHAIN=cp2k/toolchain:latest
FROM ${TOOLCHAIN}

# author: Ole Schuett

WORKDIR /workspace

COPY ./scripts/install_basics.sh .
RUN ./install_basics.sh

COPY ./scripts/install_conventions.sh .
RUN ./install_conventions.sh

COPY ./scripts/ci_entrypoint.sh ./scripts/test_conventions.sh ./
CMD ["./ci_entrypoint.sh", "./test_conventions.sh"]

#EOF

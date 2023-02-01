FROM ubuntu:18.04

# author: Ole Schuett

WORKDIR /workspace

COPY ./scripts/install_basics.sh .
RUN ./install_basics.sh

COPY ./scripts/install_python.sh .
RUN ./install_python.sh

COPY ./scripts/ci_entrypoint.sh ./scripts/test_python.sh ./
CMD ["./ci_entrypoint.sh", "./test_python.sh"]

#EOF
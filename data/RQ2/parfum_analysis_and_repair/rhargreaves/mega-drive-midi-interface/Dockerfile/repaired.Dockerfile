FROM ghcr.io/rhargreaves/docker-sgdk:v1.70-mw
USER root
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
    build-essential \
    cmake \
    gdb \
    gdbserver \
    valgrind && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY tests/cmocka* /app/tests/
COPY tests/Makefile /app/tests/Makefile
RUN make -C tests cmocka
COPY . /app
EXPOSE 2345
ENTRYPOINT []

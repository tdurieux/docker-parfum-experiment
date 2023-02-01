FROM ubuntu:21.04
ENV DEBIAN_FRONTEND=noninteractive

COPY install_libraries.sh /tmp/
RUN apt-get update && /tmp/install_libraries.sh

RUN useradd --create-home --system --shell=/bin/false builder && usermod --lock builder
USER builder

ENV PETSC_DIR="/usr/lib/petsc"

COPY pism.sh /tmp/
RUN bash /tmp/pism.sh
FROM ubuntu:20.04

ARG USER=crownlabs
ARG UID=1010

### ENV DEFAULTS
ENV USER=${USER} \
    DEBIAN_FRONTEND=noninteractive

### Install required softwares & cleanup
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl zip && \
    apt-get --purge autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*.*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER $USER

ENTRYPOINT /entrypoint.sh


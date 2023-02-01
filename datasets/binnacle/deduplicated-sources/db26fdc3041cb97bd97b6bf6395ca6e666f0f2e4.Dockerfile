FROM fedora:latest

# note: graphviz adds libX11... :'‑(
RUN dnf install -y \
                gcc \
                make findutils \
                bash \
                asciidoc \
                autoconf \
                gperf \
                zlib-devel \
        && rpm -e --nodeps graphviz \
        && dnf autoremove -y \
        && dnf clean all

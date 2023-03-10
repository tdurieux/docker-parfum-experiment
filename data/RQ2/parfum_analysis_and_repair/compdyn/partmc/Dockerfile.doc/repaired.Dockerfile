FROM fedora:33

RUN dnf -y update \
    && dnf -y install \
        less \
        tmux \
        make \
        doxygen-latex \
        graphviz \
    && dnf clean all

# NOTE: Modify .dockerignore to whitelist files/directories to copy.
COPY . /partmc/

RUN cd /partmc/doc \
    && make
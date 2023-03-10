##
## Generate an image with everything needed to build rmem from local sources
##

FROM debian:10-slim

SHELL ["/bin/bash", "-o", "pipefail", "-ceu"]

################################################################################
## Setup a user
################################################################################

ARG GUEST_UID=1000
ARG GUEST_GID=${GUEST_UID}
ARG GUEST_USER=rems
ARG GUEST_GROUP=${GUEST_USER}

# Add a user with sudo perms
RUN groupadd -g ${GUEST_GID} ${GUEST_GROUP} \
        && useradd --no-log-init -m -s /bin/bash -g ${GUEST_GROUP} -G sudo -p '' -u ${GUEST_UID} ${GUEST_USER} \
        && mkdir -p /home/${GUEST_USER}/bin \
        && chown ${GUEST_UID}:${GUEST_GID} /home/${GUEST_USER}/bin

################################################################################
## Get all the packages we need
################################################################################

ARG NJOBS="4"

RUN apt-get update -y -q \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
            autoconf \
            automake \
            build-essential \
            ca-certificates \
            curl \
            git \
            openssh-client \
            pkg-config \
            rsync \
            sudo \
            time \
            unzip \
            m4 \
            z3 \
            zlib1g-dev \
            libgmp-dev \
            gnuplot \
            # For web-interface
            gpp \
            pandoc \
            python3 \
            # For convenience:
            procps \
            htop \
            emacs \
            less \
        && rm -rf /var/lib/apt/lists/*


################################################################################
## Install opam
################################################################################

ARG OPAM_VERSION="2.0.7"

RUN binary="opam-${OPAM_VERSION}-$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" \
        && cd /tmp \
        && curl -fSOL "https://github.com/ocaml/opam/releases/download/${OPAM_VERSION}/${binary}" \
        && mv "${binary}" /usr/local/bin/opam \
        && chmod a+x /usr/local/bin/opam

################################################################################
## Use ${GUEST_USER} instead of root
################################################################################

USER ${GUEST_USER}
WORKDIR /home/${GUEST_USER}

################################################################################
## Setup opam environment with all the packages we need
################################################################################

ARG OCAML="4.07.1"

ENV OPAMPRECISETRACKING="1"

# Run opam init but do not install dependencies yet
RUN opam init --auto-setup --yes --jobs=${NJOBS} --compiler=${OCAML} --disable-sandboxing \
    && eval $(opam env) \
    && opam update -y

################################################################################
## Fetch and build herdtools7/diy7 from source, instead of the herdtools7 opam
## package above
################################################################################

#??BS: should dev- do this or only use rems things from the HEAD ?

# ARG HERDTOOLS_GIT=https://github.com/herd/herdtools7.git

# RUN set -x \
#         && git clone ${HERDTOOLS_GIT} \
#         && cd herdtools7 \
#         && mkdir temp \
#         && make all PREFIX="$(pwd)/temp" \
#         && make install PREFIX="$(pwd)/temp" \
#         && sudo chown -R root:root temp \
#         && sudo mv temp/bin/* /usr/bin/ \
#         && sudo mv temp/share/* /usr/share/ \
#         && sudo mv temp/lib/* /usr/lib/ \
#         && cd ../ && sudo rm -rf herdtools7

################################################################################
## Fetch and build all the rems dependencies
# Use HEAD of each branch rather than opam for dev
################################################################################

ARG LEM_GIT=https://github.com/rems-project/lem.git
ARG LINKSEM_GIT=https://github.com/rems-project/linksem.git
ARG SAIL_GIT=https://github.com/rems-project/sail.git
ARG SAIL2_GIT=https://github.com/rems-project/sail.git
ARG OTT_GIT=https://github.com/ott-lang/ott.git
ARG RISCV_GIT=https://github.com/rems-project/sail-riscv.git

RUN git clone ${LEM_GIT}
RUN git clone ${LINKSEM_GIT}
RUN git clone -n ${SAIL_GIT} sail \
    && git -C sail checkout legacy
RUN git clone ${SAIL2_GIT} sail2
RUN git clone ${OTT_GIT}
RUN git clone ${RISCV_GIT}

#??these must run in dependency-order
##
## Generate an image with everything needed to build rmem, but don't build rmem
##

FROM debian:10-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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

# The following packages are needed only by one target
# rmem/text: zarith, lwt, lambda-term
# rmem/web: js_of_ocaml, js_of_ocaml-ppx
RUN opam init --auto-setup --yes --jobs=${NJOBS} --compiler=${OCAML} --disable-sandboxing \
        && eval $(opam env) \
        && opam update -y \
        && opam pin add -n -k version lwt 4.1.0 \
        && opam pin add -n -k version lambda-term 1.13 \
        && opam pin add -n -k version js_of_ocaml 3.3.0 \
        && opam pin add -n -k version js_of_ocaml-ppx 3.3.0 \
        && opam install -y -v -j ${NJOBS} \
            ocamlbuild \
            menhir \
            ocamlfind \
            omd \
            linenoise \
            yojson \
            pprint \
            num \
            base64 \
            herdtools7 \
            # For the text image
            zarith \
            lwt \
            lambda-term \
            # For the web image
            js_of_ocaml \
            js_of_ocaml-ppx \
        # Clean-up
        && opam clean -a -c -s --logs \
        && opam config list && opam list

################################################################################
## Fetch and build herdtools7/diy7 from source, instead of the herdtools7 opam
## package above
################################################################################

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
## Fetch rmem (but don't build) and also fetch and build all the rems tools rmem
## depends on
################################################################################

ARG LEM_GIT=https://github.com/rems-project/lem.git
ARG LINKSEM_GIT=https://github.com/rems-project/linksem.git
ARG SAIL_GIT=https://github.com/rems-project/sail.git
ARG SAIL2_GIT=https://github.com/rems-project/sail.git
ARG OTT_GIT=https://github.com/ott-lang/ott.git
ARG RISCV_GIT=https://github.com/rems-project/sail-riscv.git

## fetch_internal_deps below will clone all the REMS tools which aren't already
## cloned. If you need a specific commit uncomment which ever tool you need:
# RUN git clone ${LEM_GIT} \
#         && git -C lem checkout ??COMMIT??
# RUN git clone ${LINKSEM_GIT} \
#         && git -C linksem checkout ??COMMIT??
# RUN git clone -n ${SAIL_GIT} sail \
#         && git -C sail checkout ??COMMIT??
# RUN git clone ${SAIL2_GIT} sail2 \
#         && git -C sail2 checkout ??COMMIT??
# RUN git clone ${OTT_GIT} \
#         && git -C ott checkout ??COMMIT??
RUN git clone ${RISCV_GIT} \
        && git -C sail-riscv checkout 710d499

ARG RMEM_GIT=https://github.com/rems-project/rmem.git

RUN git clone ${RMEM_GIT} \
        && eval $(opam env) \
        # Clone and build all the REMS tools rmem depends on
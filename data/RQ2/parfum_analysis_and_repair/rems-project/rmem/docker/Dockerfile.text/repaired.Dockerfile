FROM rmem/base as intermediate

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG MODE="opt"
ARG ISA="PPCGEN,AArch64,RISCV"

RUN eval $(opam env) \
        && ulimit -s unlimited \
        && make -C rmem rmem MODE=${MODE} UI=text ISA=${ISA} \
        && cp rmem/rmem bin/ \
        && echo 'export ISA_DEFS_PATH="$HOME/rmem/"' >> .profile

# If you want a small image that can run rmem you can copy rmem/*.defs to
# ~/bin/ and remove all the folders in ~/, except ~/bin/ and ~/.opam/. You
# can also remove most of the apt and opam packages, but I did not check which
# exactly.
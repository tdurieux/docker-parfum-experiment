FROM alpine:edge as builder

RUN apk add --no-cache curl gcc make musl-dev

RUN curl https://ftp.gnu.org/gnu/bash/bash-5.0.tar.gz | tar xzf -

RUN cd bash-5.0                \
 && ./configure                \
    --disable-command-timing   \
    --disable-debugger         \
    --disable-directory-stack  \
    --disable-help-builtin     \
    --disable-job-control      \
    --disable-net-redirections \
    --disable-progcomp         \
    --disable-select           \
    --enable-static-link       \
    --without-bash-malloc      \
 && make                       \
 && strip bash

FROM scratch

COPY --from=0 /bash-5.0/bash /usr/bin/

ENTRYPOINT ["/usr/bin/bash", "-c", "echo ${BASH_VERSION%\\([0-9]\\)-release}"]

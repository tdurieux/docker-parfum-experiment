FROM scratch
ARG JRE_VERSION
ARG ARCH
ADD ${JRE_VERSION}-${ARCH}.tar.gz /
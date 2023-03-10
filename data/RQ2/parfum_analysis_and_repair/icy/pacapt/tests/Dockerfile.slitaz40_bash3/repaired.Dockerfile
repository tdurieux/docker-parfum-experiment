FROM bash:3.2 as bash3

FROM icymatter/slitaz40-minimal

COPY --from=bash3 /usr/local/bin/bash /bin/bash
COPY --from=bash3 /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=bash3 /usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
COPY --from=bash3 /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
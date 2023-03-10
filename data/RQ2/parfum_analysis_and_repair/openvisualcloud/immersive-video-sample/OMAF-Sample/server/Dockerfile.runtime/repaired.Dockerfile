ARG base_image
FROM ${base_image} AS base

RUN cd /home/immersive/ && \
    export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH && \
    export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH && \
    ldd Sample-Videos/ffmpeg | tr -s '[:blank:]' '\n' | grep '^/' | \
    xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;' && \
    ldd /root/WorkerServer | tr -s '[:blank:]' '\n' | grep '^/' | \
    xargs -I % sh -c 'mkdir -p $(dirname deps%); cp % deps%;'

FROM centos:7.6.1810

USER 10001
WORKDIR /home/immersive/
ARG WORKDIR=/home/immersive/

COPY --from=base /etc/passwd /etc/group /etc/
COPY --chown=10001:10001 --from=base ${WORKDIR}/Sample-Videos ${WORKDIR}/Sample-Videos
COPY --chown=10001:10001 --from=base ${WORKDIR}/deps/lib64 /usr/lib64
COPY --chown=10001:10001 --from=base ${WORKDIR}/deps/usr /usr/
COPY --chown=10001:10001 --from=base /usr/local/nginx /usr/local/nginx
COPY --chown=10001:10001 --from=base /usr/local/lib/libHevcVideoStreamProcess.so /usr/local/lib/
COPY --chown=10001:10001 --from=base /usr/local/lib/libHighResPlusFullLowResPacking.so /usr/local/lib/
COPY --chown=10001:10001 --from=base /usr/local/lib/libSegmentWriter.so /usr/local/lib/
COPY --chown=10001:10001 --from=base /usr/local/lib/libMPDWriter.so /usr/local/lib/
COPY --chown=10001:10001 --from=base /usr/lib64/libnuma.so.1.0.0 /usr/lib64/
COPY --chown=10001:10001 --from=base /usr/lib64/libnuma.so.1 /usr/lib64/
COPY --chown=10001:10001 --from=base /usr/bin/numactl /usr/bin/
COPY --chown=10001:10001 --from=base /usr/bin/bc /usr/bin/
COPY --chown=10001:10001 --from=base /usr/bin/openssl /usr/bin/
COPY --chown=10001:10001 --from=base /root/WorkerServer /root/

EXPOSE 443
EXPOSE 8080
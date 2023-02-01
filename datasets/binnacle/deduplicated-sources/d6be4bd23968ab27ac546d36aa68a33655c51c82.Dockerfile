FROM alpine:latest
MAINTAINER José Moreira <jose.moreira@findhit.com>
ADD tunesys /tunesys
RUN apk add --update docker && \
    rm -rf /var/cache/apk/*
RUN chmod +x /tunesys/run /tunesys/common /tunesys/tuner/*
ENV PROC=/proc

# CACHE
ENV TUNE_CACHE=1 \
    cache_loop_interval=60 \
    sys__vm__drop_caches=3

# TCP
ENV TUNE_TCP=1 \
    tcp_loop_interval=3600 \
    net__ipv4__ip_local_port_range_min=15000 \
    net__ipv4__ip_local_port_range_max=61000 \
    net__ipv4__tcp_fin_timeout=20 \
    net__ipv4__tcp_tw_recycle=1 \
    net__ipv4__tcp_tw_reuse=1 \
    net__ipv4__tcp_max_orphans=0 \
    net__ipv4__tcp_challenge_ack_limit=999999999

# DOCKER
ENV TUNE_DOCKER=1 \
    docker_remove_containers=1 \
    docker_remove_images=1 \
    docker_remove_volumes=1 \
    docker_loop_interval=21600

WORKDIR /tunesys
CMD [ "/tunesys/run" ]

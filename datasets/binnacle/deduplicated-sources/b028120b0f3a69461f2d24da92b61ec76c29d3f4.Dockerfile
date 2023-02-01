ARG FROM_IMAGE
FROM ${FROM_IMAGE}

COPY xgb/ubuntu/omp/sbin /usr/sbin

RUN \
    chmod +x /usr/sbin/install_omp_packages && \
    sync && \
    /usr/sbin/install_omp_packages

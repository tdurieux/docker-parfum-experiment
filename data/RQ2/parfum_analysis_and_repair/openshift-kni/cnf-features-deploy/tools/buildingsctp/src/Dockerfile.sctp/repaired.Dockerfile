FROM registry.access.redhat.com/ubi8/ubi AS builder
USER root
# Copy entitlements
COPY ./etc-pki-entitlement /etc/pki/entitlement
# Copy subscription manager configurations
COPY ./rhsm-conf /etc/rhsm
COPY ./rhsm-ca /etc/rhsm/ca
# Delete /etc/rhsm-host to use entitlements from the build container
RUN rm /etc/rhsm-host && \
    yum -y update && \
    yum -y install lksctp-tools-devel gcc lksctp-tools kernel-modules-extra && \
    # Remove entitlements and Subscription Manager configs
    rm -rf /etc/pki/entitlement && \
    rm -rf /etc/rhsm && rm -rf /var/cache/yum
# OpenShift requires images to run as non-root by default
USER 1001
COPY samplebuild/src/* /src/
RUN gcc /src/sctp.c -o /src/sctpclient -lsctp

FROM registry.access.redhat.com/ubi8/ubi
COPY --from=builder /src/sctpclient /usr/local/bin/sctpclient
CMD ["/usr/bin/sctptest"]


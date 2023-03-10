ARG COLLECTOR_TAG
ARG COLLECTOR_REPO=quay.io/rhacs-eng
ARG DRIVERS_TAG=latest
ARG DRIVERS_REPO=quay.io/rhacs-eng
ARG MODULE_VERSION

FROM $DRIVERS_REPO/collector-drivers:$DRIVERS_TAG AS drivers

FROM $COLLECTOR_REPO/collector:$COLLECTOR_TAG

COPY --from=drivers /kernel-modules/$MODULE_VERSION/*.gz /kernel-modules/
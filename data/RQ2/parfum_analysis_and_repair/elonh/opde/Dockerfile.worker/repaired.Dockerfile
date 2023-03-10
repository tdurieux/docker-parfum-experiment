FROM elonh/opde:sdk
LABEL maintainer="Elon Huang <elonhhuang@gmail.com>"

RUN opde patch
RUN mv Config-build.in .Config-build.in.fixed && mv .Config-build.in.worker Config-build.in
ARG WORKER_CONF_DIR
RUN echo "${WORKER_CONF_DIR}"
COPY --chown=opde:opde ${WORKER_CONF_DIR}/ /worker
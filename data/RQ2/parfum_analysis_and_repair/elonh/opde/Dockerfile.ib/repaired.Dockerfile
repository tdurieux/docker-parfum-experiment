FROM elonh/opde:base
LABEL maintainer="Elon Huang <elonhhuang@gmail.com>"

ENV OPDE_MODE=IB
ARG IB_PATH
RUN echo "${IB_PATH}"
COPY --chown=opde:opde ${IB_PATH}/ /openwrt/
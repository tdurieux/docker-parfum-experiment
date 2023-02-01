ARG BASE_IMAGE=ghcr.io/tinyzimmer/kvdi:ubuntu-base-latest
FROM ${BASE_IMAGE}

# Window manager install
ARG DESKTOP_PACKAGE=xfce4
ENV DESKTOP_PACKAGE ${DESKTOP_PACKAGE}
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -y ${DESKTOP_PACKAGE} \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


COPY systemd/${DESKTOP_PACKAGE}.service /etc/systemd/user/desktop.service

RUN systemctl --user --global enable desktop.service \
  && systemctl disable display-manager \
  && systemctl disable wpa_supplicant \
  && systemctl disable ModemManager

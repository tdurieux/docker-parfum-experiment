ARG IMAGE=qgis/qgis
ARG QGIS_VERSION_TAG=latest
FROM ${IMAGE}:${QGIS_VERSION_TAG}

ENV \
    RDP_USERNAME=gisuser \
    RDP_PASSWORD=gisuser

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes \

    lubuntu-desktop \
    xorgxrdp \
    xrdp && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.py /opt/docker-entrypoint.py

EXPOSE 3389

ENTRYPOINT ["python3", "/opt/docker-entrypoint.py"]
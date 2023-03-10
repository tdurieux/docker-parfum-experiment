FROM cr.44net.ch/baseimages/debian-s6:1.3.5-linux-amd64

# set version label
ARG BUILD_VERSION
ENV MDLP_VERSION=${BUILD_VERSION}
LABEL version="${BUILD_VERSION}"
LABEL maintainer="Ivan Schaller"
LABEL description="A CLI manga downloader"


# install packages
RUN \
  echo "**** install base packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
      python3 \
      python3-pip \
      && \
  echo "**** creating folders ****" && \
  mkdir -p /app && \
  echo "**** cleanup ****" && \
  apt-get purge --auto-remove -y && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*


# copy files to container
COPY docker/rootfs /
COPY mangadlp/ /app/mangadlp/
COPY manga-dlp.py \
     requirements.txt \
     LICENSE \
        /app/


# install requirements
RUN pip install --no-cache-dir -r /app/requirements.txt

WORKDIR /app

# Copyright (C) 2016-2017 Bitergia
# GPLv3 License
#
# Build GrimoireLab packages, install them, check them
#

FROM grimoirelab/full
MAINTAINER Jesus M. Gonzalez-Barahona <jgb@bitergia.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN wget https://github.com/fossology/fossology/releases/download/3.8.1/FOSSology-3.8.0-debian9stretch.tar.gz && \
    tar -xzf FOSSology-3.8.0-debian9stretch.tar.gz && rm FOSSology-3.8.0-debian9stretch.tar.gz && \
    cp packages/fossology-common_3.8.1-1_amd64.deb /tmp && \
    cp packages/fossology-nomos_3.8.1-1_amd64.deb /tmp

RUN rm -rf packages

# install dependencies
RUN sudo apt-get update && \
    sudo apt-get -y --no-install-recommends install /tmp/fossology-common_3.8.1-1_amd64.deb \
     /tmp/fossology-nomos_3.8.1-1_amd64.deb \
     cloc \
        && \
    sudo apt-get clean && \
    sudo find /var/lib/apt/lists -type f -delete && \
    sudo rm /tmp/fossology-common_3.8.1-1_amd64.deb \
       /tmp/fossology-nomos_3.8.1-1_amd64.deb && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/crossminer/crossJadolint/releases/download/Pre-releasev2/jadolint.jar

# Entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-c", "/infra.cfg", "/dashboard.cfg", "/project.cfg", "/override.cfg"]

# Copyright (C) 2016-2017 Bitergia
# GPLv3 License
#
# The container produced with this file contains all
# GrimoireLab libraries and executables, and is configured
# for running mordred by default
#
FROM debian:stretch-slim
MAINTAINER Jesus M. Gonzalez-Barahona <jgb@bitergia.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV DEPLOY_USER=grimoirelab
ENV DEPLOY_USER_DIR=/home/${DEPLOY_USER}
ENV DIST_SCRIPT=/usr/local/bin/build_grimoirelab \
    LOGS_DIR=/logs \
    DIST_DIR=/dist

# install dependencies
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        bash locales \
        gcc \
        git git-core \
        pandoc \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        python3-gdbm \
        mariadb-client \
        texlive-latex-base \
        texlive-latex-extra \
        latex-cjk-common \
        unzip curl wget sudo ssh \
        && \
    apt-get clean && \
    find /var/lib/apt/lists -type f -delete && rm -rf /var/lib/apt/lists/*;

# Initial user and dirs
RUN useradd ${DEPLOY_USER} --create-home --shell /bin/bash ; \
    echo "${DEPLOY_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers ; \
    mkdir ${DIST_DIR} ; chown -R ${DEPLOY_USER}:${DEPLOY_USER} ${DIST_DIR} ; \
    mkdir ${LOGS_DIR} ; chown -R ${DEPLOY_USER}:${DEPLOY_USER} ${LOGS_DIR}

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    LANG=C.UTF-8

# Add script to create distributable packages
# Add script to create distributable packages
ADD utils/build_grimoirelab ${DIST_SCRIPT}
RUN chmod 755 ${DIST_SCRIPT}

# Add packages (should be in dist, when building)
ADD docker/dist/* ${DIST_DIR}/

# Unbuffered output for Python, so that we see messages as they are produced
ENV PYTHONUNBUFFERED 0
# Install GrimoireLab from packages in DIST_DIR
RUN ${DIST_SCRIPT} --install --install_system --distdir ${DIST_DIR}

# Add default mordred configuration files
ADD docker/mordred-infra.cfg /infra.cfg
ADD docker/mordred-dashboard.cfg /dashboard.cfg
ADD docker/mordred-project.cfg /project.cfg
ADD docker/mordred-override.cfg /override.cfg
ADD docker/orgs.json /orgs.json
ADD docker/projects.json /projects.json
ADD docker/identities.yaml /identities.yaml
ADD docker/menu.yaml /menu.yaml
ADD docker/aliases.json /aliases.json

USER ${DEPLOY_USER}
WORKDIR ${DEPLOY_USER_DIR}

# Entrypoint (mordred)
ENTRYPOINT [ "/usr/local/bin/sirmordred" ]
CMD [ "-c", "/infra.cfg", "/dashboard.cfg", "/project.cfg", "/override.cfg"]

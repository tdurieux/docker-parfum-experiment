FROM alpine:3.6

# metadata
MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )
#
# set the term var
ENV TERM xterm-256color

# wft4galaxy path
ENV WFT4GALAXY_PATH /opt/wft4galaxy

# Copy the wft4galaxy project, skipping hidden files (such as the .git repo)
COPY "." "${WFT4GALAXY_PATH}"

# install base packages
RUN echo "Installing dependencies" >&2 \
    && apk update && apk add \
        bash \
        build-base \
        gcc \
        git \
        make \
        py-lxml \
        py-pip \
        py-setuptools \
        python \
        python-dev \
    && pip install --no-cache-dir --upgrade pip \
    && cd ${WFT4GALAXY_PATH} \
    && pip install --no-cache-dir -r requirements.txt \
    && echo "Building and installing wft4galaxy" >&2 \
    && python setup.py install \
    && echo "Removing build-time dependencies" >&2 \
    && apk del \
        build-base \
        gcc \
        git \
        make \
        py-pip \
        python-dev \
    && rm -rf /var/cache/apk/*

# Don't bother removing /opt/wft4galaxy since we've already committed that step

# setup bash custom prompt (PS1)
ADD utils/docker/bashrc /root/.bashrc

# update the working dir
WORKDIR /root

# add container entrypoint
COPY utils/docker/minimal/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY utils/docker/entrypoint-argparser.sh /usr/local/bin/entrypoint-argparser.sh

# set the entrypoint
ENTRYPOINT ["entrypoint.sh"]

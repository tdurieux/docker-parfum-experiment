FROM alpine:3.6

# metadata
MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

# allow user defined Git repository
ARG git_url
ARG git_branch

# set the term var
ENV TERM xterm-256color

# wft4galaxy path
ENV WFT4GALAXY_PATH /opt/wft4galaxy

# set Git repository url
ENV WFT4GALAXY_REPOSITORY_URL ${git_url:-"https://github.com/phnmnl/wft4galaxy"}

# wft4galaxy branch
ENV WFT4GALAXY_BRANCH ${git_branch:-develop}

# install base packages
RUN echo "Installing dependencies" >&2 \
    && apk update && apk add \
        bash \
        build-base \
        gcc \
        git \
        make \
        python \
        python-dev \
        py-lxml \
        py-pip \
        py-setuptools \
    && pip install --no-cache-dir --upgrade pip \
    && echo "Cloning wft4galaxy: branch=${WFT4GALAXY_BRANCH} url=${WFT4GALAXY_REPOSITORY_URL}" >&2 \
    && git clone --single-branch --depth 1 -b ${WFT4GALAXY_BRANCH} ${WFT4GALAXY_REPOSITORY_URL} ${WFT4GALAXY_PATH} \
    && cd ${WFT4GALAXY_PATH} \
    && pip install --no-cache-dir -r requirements.txt \
    && echo "Building and installing wft4galaxy" >&2 \
    && python setup.py install \
    && echo "Removing build-time dependencies" >&2 \
    && apk del \
        build-base \
        gcc \
        make \
        git \
        python-dev \
        py-pip \
    && rm -rf ${WFT4GALAXY_PATH} \
    && rm -rf /var/cache/apk/*

# setup bash custom prompt (PS1)
ADD utils/docker/bashrc /root/.bashrc

# update the working dir
WORKDIR /root

# add container entrypoint
COPY utils/docker/minimal/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY utils/docker/entrypoint-argparser.sh /usr/local/bin/entrypoint-argparser.sh

# set the entrypoint
ENTRYPOINT ["entrypoint.sh"]

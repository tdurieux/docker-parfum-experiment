FROM pypy:2.7-buster

ENV WHEELHOUSE_PATH /tmp/wheelhouse
ENV VIRTUALENV_PATH /tmp/venv
# This will get updated by the CircleCI checkout step.
ENV BUILD_SRC_ROOT /tmp/project

RUN apt-get --quiet update && \
    apt-get --quiet --no-install-recommends --yes install \
        git \
        lsb-release \
        sudo \
        build-essential \
        libffi-dev \
        libssl-dev \
        libyaml-dev \
        virtualenv && rm -rf /var/lib/apt/lists/*;

# Get the project source.  This is better than it seems.  CircleCI will
# *update* this checkout on each job run, saving us more time per-job.
COPY . ${BUILD_SRC_ROOT}

RUN "${BUILD_SRC_ROOT}"/.circleci/prepare-image.sh "${WHEELHOUSE_PATH}" "${VIRTUALENV_PATH}" "${BUILD_SRC_ROOT}" "pypy"

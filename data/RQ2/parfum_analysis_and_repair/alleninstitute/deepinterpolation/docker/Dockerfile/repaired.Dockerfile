FROM tensorflow/tensorflow:2.2.2-gpu

ARG REPO_TAG="master"
ARG COMMIT="unspecified to docker build"

RUN adduser deepuser

ENV REPOS=/home/deepuser/repos
ENV REPO=/home/deepuser/repos/deepinterpolation
ENV CONDA_ENVS_PATH=/home/deepuser/envs
ENV CONDA_PKGS_DIRS=/home/deepuser/pkgs
ENV CONDA_ENV_NAME=deep_env
ENV DEEPINTERPOLATION_COMMIT_SHA=${COMMIT}
ENV TMPDIR=/tmp

RUN apt-get update \
    && apt-get -y --no-install-recommends install git python3-pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir ${REPOS} \
    && git clone -b ${REPO_TAG} https://github.com/AllenInstitute/deepinterpolation ${REPO} \
    && pip install --no-cache-dir ${REPO}

USER deepuser

ENTRYPOINT ["/bin/bash", "-c", "$@", "--"]

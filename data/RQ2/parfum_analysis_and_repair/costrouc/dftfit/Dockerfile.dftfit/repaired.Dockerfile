FROM registry.gitlab.com/costrouc/dftfit/base:patch_11May2018
MAINTAINER Chris Ostrouchov "chris.ostrouchov@gmail.com"

ARG USERNAME="costrouc"
ARG PROJECT="dftfit"
ARG VERSION="v0.4.1"

RUN python -m pip install numpy cython mpi4py && \
    python -m pip install --no-cache-dir https://gitlab.com/$USERNAME/$PROJECT/repository/$VERSION/archive.tar.gz
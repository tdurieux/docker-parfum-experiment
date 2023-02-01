#
FROM muccg/yabi-base
LABEL maintainer "https://github.com/muccg/"

# TODO
#ARG ARG_GIT_TAG=next_release
#ENV GIT_TAG $ARG_GIT_TAG

ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL "https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST "127.0.0.1"
ENV NO_PROXY ${PIP_TRUSTED_HOST}

RUN env | sort

# Project specific deps
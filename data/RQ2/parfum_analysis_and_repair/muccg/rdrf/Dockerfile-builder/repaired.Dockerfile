#
FROM muccg/rdrf-base
MAINTAINER https://github.com/muccg/rdrf

ENV PIP_NO_CACHE_DIR="off"
ENV PIP_INDEX_URL "https://pypi.python.org/simple"
ENV PIP_TRUSTED_HOST "127.0.0.1"
ENV NO_PROXY ${PIP_TRUSTED_HOST}

RUN env | sort

# Project specific deps
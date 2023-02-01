FROM stimela/ddfacet:1.7.0
MAINTAINER <sphemakh@gmail.com>
ENV GIT_LFS_SKIP_SMUDGE 1
RUN pip3 install --no-cache-dir -U pip setuptools wheel
RUN apt-get update && apt-get install --no-install-recommends -y wget git-all && rm -rf /var/lib/apt/lists/*;
RUN git clone -b v1.5.11 https://github.com/ratt-ru/CubiCal
WORKDIR CubiCal
RUN pip3 install --no-cache-dir ".[lsm-support,degridder-support]"
RUN DDF.py --help
RUN gocubical --help
ENV NUMBA_CACHE_DIR /tmp
ENTRYPOINT []

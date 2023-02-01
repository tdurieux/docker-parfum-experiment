# -----------------------------------------------------------------------------
# Dockerfile for Larynx (https://github.com/rhasspy/larynx)
# See scripts/build-docker.sh
#
# The IFDEF statements are handled by docker/preprocess.sh. These are just
# comments that are uncommented if the environment variable after the IFDEF is
# not empty.
#
# The build-docker.sh script will optionally add apt/pypi proxies running locally:
# * apt - https://docs.docker.com/engine/examples/apt-cacher-ng/
# * pypi - https://github.com/jayfk/docker-pypi-cache
# -----------------------------------------------------------------------------

FROM debian:buster-slim as build

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${APT_PROXY_HOST}:${APT_PROXY_PORT}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 python3-pip python3-venv python3-dev \
        build-essential curl && rm -rf /var/lib/apt/lists/*;

# IFDEF PYPI
#! ENV PIP_INDEX_URL=http://${PYPI_PROXY_HOST}:${PYPI_PROXY_PORT}/simple/
#! ENV PIP_TRUSTED_HOST=${PYPI_PROXY_HOST}
# ENDIF

ENV DOWNLOAD_DIR /app/download

COPY requirements.txt /app/
COPY scripts/create-venv.sh /app/scripts/
COPY TTS/ /app/TTS/


ARG TARGETARCH
ARG TARGETVARIANT

COPY download/$TARGETARCH$TARGETVARIANT/ /app/download/
COPY download/shared/ /app/download/

# IFDEF NOAVX
#! RUN mv /app/download/noavx/* /app/download/
# ENDIF

RUN cd /app && \
    export stage=0 end_stage=0 && \
    scripts/create-venv.sh

# Install app
RUN cd /app && \
    export PIP_INSTALL='install -f /app/download' && \
    export SETUP_DEVELOP='-f /app/download' && \
    export PIP_PREINSTALL_PACKAGES='numpy==1.19.0 scipy==1.5.1' && \
    scripts/create-venv.sh

# -----------------------------------------------------------------------------

FROM debian:buster-slim as run

ENV LANG C.UTF-8

# IFDEF PROXY
#! RUN echo 'Acquire::http { Proxy "http://${APT_PROXY_HOST}:${APT_PROXY_PORT}"; };' >> /etc/apt/apt.conf.d/01proxy
# ENDIF

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 python3-distutils python3-llvmlite libpython3.7 \
        libsndfile1 libgomp1 libatlas3-base libgfortran4 libopenblas-base \
        libnuma1 \
        espeak-ng && rm -rf /var/lib/apt/lists/*;

# Remove proxy
# IFDEF PROXY
#! RUN rm -f /etc/apt/apt.conf.d/01proxy
#! ENV PIP_INDEX_URL=''
#! ENV PIP_TRUSTED_HOST=''
# ENDIF

# Copy virtual environment
COPY --from=build /app/.venv/ /app/.venv/

# Copy TTS with compiled extension
COPY --from=build /app/TTS/ /app/TTS/

# Copy other files
COPY larynx/ /app/larynx/

# Need this since we installed numba as root but will be running as a regular user
ENV NUMBA_CACHE_DIR=/tmp

WORKDIR /app

EXPOSE 5002

ENTRYPOINT ["/app/.venv/bin/python3", "-m", "larynx", "serve"]

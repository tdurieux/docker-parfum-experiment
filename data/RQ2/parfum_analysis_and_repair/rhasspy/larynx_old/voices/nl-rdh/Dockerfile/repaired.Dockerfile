# -----------------------------------------------------------------------------
# Dockerfile for Larynx (https://github.com/rhasspy/larynx)
# Contains Dutch rdh voice (https://github.com/rhasspy/nl_larynx-rdh)
#
# Application code and voice are at /app
# WAV files are cached at /cache
#
# Requires Docker buildx: https://docs.docker.com/buildx/working-with-buildx/
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

ARG DOCKER_REGISTRY
FROM $DOCKER_REGISTRY/rhasspy/larynx

# Remove proxy
# IFDEF PROXY
#! RUN rm -f /etc/apt/apt.conf.d/01proxy
# ENDIF

# IFDEF PYPI
#! ENV PIP_INDEX_URL=''
#! ENV PIP_TRUSTED_HOST=''
# ENDIF
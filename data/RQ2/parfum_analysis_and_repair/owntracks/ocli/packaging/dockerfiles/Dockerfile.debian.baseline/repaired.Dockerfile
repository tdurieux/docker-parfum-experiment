ARG BASE_IMAGE


# =========================
# Derive from superbaseline
# =========================
FROM ${BASE_IMAGE} AS debian-base
RUN apt-get update && apt-get upgrade


# ===========
# Build tools
# ===========
FROM debian-base AS debian-build

# Build foundation and header files
RUN apt-get install --yes --no-install-recommends \
    apt-utils git nano \
    build-essential pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;


# ===============
# Packaging tools
# ===============
FROM debian-build AS debian-fpm

# FPM
RUN echo && echo "Installing fpm. This might take a while." && echo
RUN apt-get install --yes --no-install-recommends \
    ruby ruby-dev && \
    gem install fpm --version 1.11.0 && rm -rf /var/lib/apt/lists/*;


# ===========================
# Customize build environment
# ===========================
FROM debian-fpm

RUN apt-get install --yes --no-install-recommends libgps-dev libmosquitto-dev && rm -rf /var/lib/apt/lists/*;

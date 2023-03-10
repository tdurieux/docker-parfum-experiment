# Copyright 2022 Mycroft AI Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# -----------------------------------------------------------------------------
# Dockerfile for Mimic 3 (https://github.com/MycroftAI/mimic3)
#
# Creates source code distributions for PyPI.
#
# Requires Docker buildx: https://docs.docker.com/buildx/working-with-buildx/
# -----------------------------------------------------------------------------
FROM debian:bullseye as build
ARG TARGETARCH
ARG TARGETVARIANT

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Dir::Cache var/cache/apt/${TARGETARCH}${TARGETVARIANT};" > /etc/apt/apt.conf.d/01cache

RUN --mount=type=cache,id=apt-build,target=/var/cache/apt \
    mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 python3-venv python3-pip && rm -rf /var/lib/apt/lists/*;

WORKDIR /build/mimic3

COPY wheels/ ./wheels/

COPY opentts_abc/ ./opentts_abc/
COPY mimic3_http/ ./mimic3_http/
COPY mimic3_tts/ ./mimic3_tts/
COPY LICENSE MANIFEST.in README.md setup.py requirements.txt ./
COPY build-dist.sh ./

# Create sdists
RUN ./build-dist.sh

# -----------------------------------------------------------------------------

FROM debian:bullseye as test
ARG TARGETARCH
ARG TARGETVARIANT

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Dir::Cache var/cache/apt/${TARGETARCH}${TARGETVARIANT};" > /etc/apt/apt.conf.d/01cache

COPY debian/control.in.* ./debian/

# Use dependencies from Debian package control file
RUN --mount=type=cache,id=apt-run,target=/var/cache/apt \
    mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
    apt-get update && \
    grep 'Depends:' "debian/control.in.${TARGETARCH}${TARGETVARIANT}" | cut -d' ' -f2- | sed -e 's/,/\n/g' | \
    xargs apt-get install --yes --no-install-recommends \
        python3 python3-venv python3-pip \
        build-essential python3-dev

WORKDIR /test

COPY wheels/ ./wheels/

COPY --from=build /build/mimic3/dist/*.tar.gz ./dist/

# Install mimic3 using source distribution
RUN --mount=type=cache,id=pip-requirements,target=/root/.cache/pip \
    python3 -m venv .venv && \
    .venv/bin/pip3 install --upgrade pip && \
    .venv/bin/pip3 install --upgrade wheel setuptools && \
    .venv/bin/pip3 install \
        -f wheels/ \
        -f https://synesthesiam.github.io/prebuilt-apps/ \
        -f dist/ \
        mycroft-mimic3-tts

# Download default voice
COPY voices/ /root/.local/share/mycroft/mimic3/voices/
RUN .venv/bin/mimic3-download --debug 'en_UK/apope_low'

# Run test
COPY tests/* tests/

# Generate sample and check
RUN export expected_sample="tests/apope_sample_${TARGETARCH}${TARGETVARIANT}.wav" && \
    .venv/bin/mimic3 \
    --deterministic \
    --voice 'en_UK/apope_low' \
    < tests/apope_sample.txt \
    > tests/actual_sample.wav && \
    tests/samples_match.py tests/actual_sample.wav "${expected_sample}"

# -----------------------------------------------------------------------------

FROM scratch
ARG TARGETARCH
ARG TARGETVARIANT

COPY --from=build /build/mimic3/dist/*.tar.gz /

# Ensure test runs
COPY --from=test /test/tests/actual_sample.wav "/apope_sample_${TARGETARCH}${TARGETVARIANT}.wav"

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
# Builds and tests TTS plugin with Mycroft.
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

# Build plugin sdist
COPY plugin-tts-mimic3/ ./plugin-tts-mimic3/
RUN cd plugin-tts-mimic3 && \
    python3 setup.py sdist && \
    cp dist/*.tar.gz ../dist/

# -----------------------------------------------------------------------------

# FROM debian:bullseye as test
# ARG TARGETARCH
# ARG TARGETVARIANT

# ENV LANG C.UTF-8
# ENV DEBIAN_FRONTEND=noninteractive

# RUN echo "Dir::Cache var/cache/apt/${TARGETARCH}${TARGETVARIANT};" > /etc/apt/apt.conf.d/01cache

# COPY debian/control.in.* ./debian/

# # Use dependencies from Debian package control file
# RUN --mount=type=cache,id=apt-run,target=/var/cache/apt \
#     mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
#     apt-get update && \
#     grep 'Depends:' "debian/control.in.${TARGETARCH}${TARGETVARIANT}" | cut -d' ' -f2- | sed -e 's/,/\n/g' | \
#     xargs apt-get install --yes --no-install-recommends \
#         python3 python3-venv python3-pip \
#         build-essential python3-dev \
#         git inotify-tools sox procps

# WORKDIR /test

# # Install Mycroft
# RUN git clone --single-branch --branch dev https://github.com/MycroftAI/mycroft-core.git

# RUN --mount=type=cache,id=apt-run,target=/var/cache/apt \
#     --mount=type=cache,id=pip-requirements,target=/root/.cache/pip \
#     cd mycroft-core && \
#     CI=true bash dev_setup.sh --allow-root -sm

# COPY wheels/ ./wheels/

# COPY --from=build /build/mimic3/dist/*.tar.gz ./dist/

# # Install TTS plugin
# RUN --mount=type=cache,id=pip-requirements,target=/root/.cache/pip \
#     mycroft-core/bin/mycroft-pip install --upgrade pip && \
#     mycroft-core/bin/mycroft-pip install \
#         -f wheels/ \
#         -f https://synesthesiam.github.io/prebuilt-apps/ \
#         -f dist/ \
#         mycroft-plugin-tts-mimic3

# # Download default voice
# COPY voices/ /root/.local/share/mycroft/mimic3/voices/
# RUN mycroft-core/.venv/bin/mimic3-download --debug 'en_UK/apope_low'

# # Enable plugin
# RUN mkdir -p /root/.config/mycroft && \
#     echo '{ "tts": { "module": "mimic3_tts_plug" , "mimic3_tts_plug": { "length_scale": 1.0, "noise_scale": 0.0, "noise_w": 0.0, "use_deterministic_compute": true  } } }' \
#     > /root/.config/mycroft/mycroft.conf

# # Run test
# COPY tests/* tests/

# ENV USER root
# ENV MIMIC_DIR /tmp/mycroft/cache/tts/Mimic3TTSPlugin

# # Start relevant services:
# # 1. Start message bus, wait for ready message in log (10 min timeout)
# # 2. Start audio service, wait for ready message in log (10 min timeout)
# # 3. Run mycroft-speak with sample text
# # 4. Watch cache directory for a file creation (10 min timeout)
# # 5. Copy first WAV file to known location
# RUN export timeout_sec='600' && \
#     mycroft-core/bin/mycroft-start bus && \
#     timeout "${timeout_sec}" tail -n+0 -f /var/log/mycroft/bus.log | grep -iq 'message bus service started' && \
#     echo 'Message bus started' && \
#     mycroft-core/bin/mycroft-start audio && \
#     timeout "${timeout_sec}" tail -n+0 -f /var/log/mycroft/audio.log | grep -iq 'audio service is ready' && \
#     echo 'Audio service started' && \
#     xargs -a tests/apope_sample.txt mycroft-core/bin/mycroft-speak && \
#     echo 'Speak request sent' && \
#     mkdir -p "${MIMIC_DIR}" && \
#     for i in $(seq 1 "${timeout_sec}"); do \
#         wav_path="$(find "${MIMIC_DIR}" -name '*.wav' | head -n1)"; \
#         if [ -n "${wav_path}" ]; then \
#             mv "${wav_path}" tests/actual_sample.wav; \
#             break; \
#         fi; \
#         sleep 1; \
#         echo "${i}/${timeout_sec}: Looking for WAV file in ${MIMIC_DIR}"; \
#     done

# # Check sample
# RUN export expected_sample="tests/apope_sample_${TARGETARCH}${TARGETVARIANT}.wav" && \
#     tests/samples_match.py tests/actual_sample.wav "${expected_sample}"

# RUN --mount=type=cache,id=pip-requirements,target=/root/.cache/pip \
#     mkdir -p pip && \
#     cp -R /root/.cache/pip/* pip/

# -----------------------------------------------------------------------------

FROM scratch
ARG TARGETARCH
ARG TARGETVARIANT

# Ensure test runs
# COPY --from=test /test/tests/actual_sample.wav "/apope_sample_${TARGETARCH}${TARGETVARIANT}.wav"
# COPY --from=test /var/log/mycroft/audio.log ./

COPY --from=build /build/mimic3/plugin-tts-mimic3/dist/*.tar.gz ./

# COPY --from=test /test/pip/ ./pip/

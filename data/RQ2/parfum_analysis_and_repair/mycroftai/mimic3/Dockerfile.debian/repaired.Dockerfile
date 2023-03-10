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
# Creates self-contained binaries using PyInstaller
# (https://pyinstaller.readthedocs.io/en/stable/).
#
# Packages into a Debian (.deb) package.
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
       python3 python3-pip python3-venv \
       build-essential python3-dev \
       libespeak-ng1 dpkg-dev rsync gettext-base && rm -rf /var/lib/apt/lists/*;

WORKDIR /build/mimic3

COPY wheels/ ./wheels/

COPY opentts_abc/ ./opentts_abc/
COPY mimic3_http/ ./mimic3_http/
COPY mimic3_tts/ ./mimic3_tts/
COPY LICENSE MANIFEST.in README.md setup.py requirements.txt ./
COPY install.sh ./

# Install mimic3
RUN --mount=type=cache,id=pip-venv,target=/root/.cache/pip \
    ./install.sh

# Install PyInstaller
RUN --mount=type=cache,id=pip-venv,target=/root/.cache/pip \
    .venv/bin/pip3 install -f wheels 'pyinstaller>=4,<5'

COPY pyinstaller/mimic3.py ./pyinstaller/

# Create binary
RUN .venv/bin/pyinstaller \
    --noconfirm \
    --name mimic3 \
    --hidden-import 'pycrfsuite._dumpparser' \
    --hidden-import 'pycrfsuite._logparser' \
    --collect-binaries 'onnxruntime' \
    --collect-data 'gruut' \
    --hidden-import "gruut_lang_de" \
    --collect-data "gruut_lang_de" \
    --hidden-import "gruut_lang_en" \
    --collect-data "gruut_lang_en" \
    --hidden-import "gruut_lang_es" \
    --collect-data "gruut_lang_es" \
    --hidden-import "gruut_lang_fr" \
    --collect-data "gruut_lang_fr" \
    --hidden-import "gruut_lang_it" \
    --collect-data "gruut_lang_it" \
    --hidden-import "gruut_lang_nl" \
    --collect-data "gruut_lang_nl" \
    --hidden-import "gruut_lang_ru" \
    --collect-data "gruut_lang_ru" \
    --hidden-import "gruut_lang_sw" \
    --collect-data "gruut_lang_sw" \
    --hidden-import "gruut_lang_fa" \
    --collect-data "gruut_lang_fa" \
    --collect-data 'espeak_phonemizer' \
    --collect-data 'phonemes2ids' \
    --hidden-import 'swagger_ui' \
    --hidden-import 'epitran' \
    --hidden-import 'hazm' \
    --collect-data 'hazm' \
    --collect-data 'panphon' \
    --collect-data 'mimic3_tts' \
    --collect-data 'mimic3_http' \
    --add-data $(find /usr/lib -name libespeak-ng.so.1 | head -n1):. \
    pyinstaller/mimic3.py

# Have to manually copy these over for some reason
RUN find .venv -name 'wapiti' -type d -exec cp -R {} dist/mimic3/ \;
RUN find .venv -name 'libwapiti.*.so' -type f -exec cp {} dist/mimic3/ \;

# Clean up unused lexicons
RUN find dist/mimic3/ -wholename '*/gruut_lang_*/espeak' -type d | \
    while read -r espeak_dir; do \
        rm -rf "${espeak_dir}"; \
    done

# Copy convenience scripts
COPY pyinstaller/mimic3-server \
    pyinstaller/mimic3-download \
    dist/mimic3/

# Create Debian package
ENV package_dir=/package/mycroft-mimic3-tts

COPY debian/ debian/
COPY voices/ voices/

RUN mkdir -p "${package_dir}/DEBIAN" && \
    export VERSION="$(cat mimic3_tts/VERSION)" && \
    envsubst \
    < "debian/control.in.${TARGETARCH}${TARGETVARIANT}" \
    > "${package_dir}/DEBIAN/control" && \
    mkdir -p "${package_dir}/usr/lib/mycroft/mimic3" && \
    rsync -av "dist/mimic3/" "${package_dir}/usr/lib/mycroft/mimic3/" && \
    mkdir -p "${package_dir}/usr/bin/" && \
    rsync -av "debian/bin/" "${package_dir}/usr/bin/" && \
    export dest_voice_dir="${package_dir}/usr/share/mycroft/mimic3/voices/en_UK/apope_low" && \
    mkdir -p "${dest_voice_dir}" && \
    rsync -av "voices/en_UK/apope_low/" "${dest_voice_dir}/" && \
    cd /package && \
    dpkg --build 'mycroft-mimic3-tts' && \
    dpkg-name ./*.deb

# -----------------------------------------------------------------------------

FROM debian:bullseye as test
ARG TARGETARCH
ARG TARGETVARIANT

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Dir::Cache var/cache/apt/${TARGETARCH}${TARGETVARIANT};" > /etc/apt/apt.conf.d/01cache

RUN --mount=type=cache,id=apt-run,target=/var/cache/apt \
    mkdir -p /var/cache/apt/${TARGETARCH}${TARGETVARIANT}/archives/partial && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
        dpkg-dev python3 && rm -rf /var/lib/apt/lists/*;

WORKDIR /test

COPY --from=build /package/*.deb ./
COPY mimic3_tts/VERSION ./

# Install mimic3 for current architecture
RUN --mount=type=cache,id=apt-run,target=/var/cache/apt \
    export mimic3_version="$(cat VERSION)" && \
    dpkg-architecture | \
    grep 'DEB_HOST_ARCH=' | \
    sed -e 's/.\+=//' | \
    xargs printf "./mycroft-mimic3-tts_${mimic3_version}_%s.deb" | \
    xargs apt install --yes

# Run test
COPY tests/* tests/

# Generate sample and check
RUN export expected_sample="tests/apope_sample_${TARGETARCH}${TARGETVARIANT}.wav" && \
    mimic3 \
    --deterministic \
    --voice 'en_UK/apope_low' \
    < tests/apope_sample.txt \
    > tests/actual_sample.wav && \
    tests/samples_match.py tests/actual_sample.wav "${expected_sample}"

# -----------------------------------------------------------------------------

FROM scratch
ARG TARGETARCH
ARG TARGETVARIANT

COPY --from=build /package/*.deb /

# Ensure test runs
COPY --from=test /test/tests/actual_sample.wav "/apope_sample_${TARGETARCH}${TARGETVARIANT}.wav"

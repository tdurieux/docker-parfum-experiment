# start with slim version
FROM python:3.9-slim
MAINTAINER Riverbed Technology

RUN set -ex \
        && install=' \
                git \
                less \
                vim \
                libpcap-dev \
        ' \
        && apt-get update && apt-get install -y $install --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN set -ex \
        && buildDeps=' \
                g++ \
                libssl-dev \
                libffi-dev \
        ' \
        && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \

        && pip install --no-cache-dir --src /src \
            -e git+https://github.com/riverbed/steelscript#egg=steelscript \
            -e git+https://github.com/riverbed/steelscript-netprofiler#egg \
            -e git+https://github.com/riverbed/steelscript-wireshark#egg=s \
            -e git+https://github.com/riverbed/steelscript-cmdline#egg=ste \
            -e git+https://github.com/riverbed/steelscript-scc#egg=steelsc \
            -e git+https://github.com/riverbed/steelscript-appresponse#egg \
        && pip install --no-cache-dir Cython \
        && pip install --no-cache-dir --src /src \
            -e git+https://github.com/riverbed/steelscript-steelhead#egg=steelscript-steelhead \
            -e git+https://github.com/riverbed/steelscript-packets.git@master#egg=steelscript- \
        && rm -f /src/pip-delete-this-directory.txt \
        && apt-get purge -y --auto-remove $buildDeps \
        && rm -rf ~/.cache

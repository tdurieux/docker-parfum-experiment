FROM python:3.9
MAINTAINER Riverbed Technology

# separate out steelhead package to it picks up already installed dependencies
RUN set -ex \
        && buildDeps=' \
                libpcap-dev \
        ' \
        && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \

        && pip install --no-cache-dir --src /src \
            -e git+https://github.com/riverbed/steelscript#egg=steelscript \
            -e git+https://github.com/riverbed/steelscript-netprofiler#egg \
            -e git+https://github.com/riverbed/steelscript-wireshark#egg=s \
            -e git+https://github.com/riverbed/steelscript-cmdline#egg=ste \
            -e git+https://github.com/riverbed/steelscript-scc#egg=steelsc \
            -e git+https://github.com/riverbed/steelscript-appresponse#egg \
            -e git+https://github.com/riverbed/steelscript-netim.git#egg=s \
            -e git+https://github.com/riverbed/steelscript-client-accelera \
        && pip install --no-cache-dir Cython \
        && pip install --no-cache-dir --src /src \
            -e git+https://github.com/riverbed/steelscript-steelhead#egg=steelscript-steelhead \
            -e git+https://github.com/riverbed/steelscript-packets.git@master#egg=steelscript- \
        && rm -f /src/pip-delete-this-directory.txt \
        && rm -rf ~/.cache

RUN set -ex \
        && steel mkworkspace -d /root/steelscript-workspace

WORKDIR /root/steelscript-workspace

# Configure container startup
CMD ["/bin/bash"]

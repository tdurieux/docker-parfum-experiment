# Copyright (C) 2020-2021 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

# If your machine is behind a proxy, make sure you set it up in ~/.docker/config.json

FROM ubuntu:18.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG INSTALL_SOURCES="no"
WORKDIR /thirdparty

RUN dpkg --get-selections | grep -v deinstall | awk '{print $1}' > base_packages.txt  && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server=\* \
        python3.8=\* \
        python3-distutils=\* \
        curl=\* \
        ca-certificates=\* && \
    if [ "$INSTALL_SOURCES" = "yes" ]; then \
        dpkg --get-selections | grep -v deinstall | awk '{print $1}' > all_packages.txt && \
        sed -Ei 's/# deb-src /deb-src /' /etc/apt/sources.list && \
        apt-get update && \
        grep -v -f base_packages.txt all_packages.txt | while read -r line; do \
            package=$line; \
            name=("${package//:/ }"); \
            echo "${name[0]}" >> all_dependencies.txt; \
            echo "${name[0]}" >> licenses.txt;\
            cat /usr/share/doc/"${name[0]}"/copyright >> licenses.txt; \
            grep -lE 'GPL|MPL|EPL' /usr/share/doc/"${name[0]}"/copyright; \
            exit_status=$?; \
            if [ $exit_status -eq 0 ]; then \
                apt-get source -q --download-only "$package";  \
            fi \
        done && rm -rf ./*packages.txt && \
        echo "Download source for $(find . | wc -l) third-party packages: $(du -sh)"; fi && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /openfl
COPY . .

# Install pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && rm -rf get-pip.py
RUN pip install --no-cache-dir .
WORKDIR /thirdparty
RUN if [ "$INSTALL_SOURCES" = "yes" ]; then \
    pip install --no-cache-dir pip-licenses; \
    pip-licenses -l >> licenses.txt; \
    pip-licenses | awk '{for(i=1;i<=NF;i++) if(i!=2) printf $i" "; print ""}' | tee -a all_dependencies.txt; \
    pip-licenses | grep -E 'GPL|MPL|EPL' | awk '{OFS="=="} {print $1,$2}' | xargs pip download --no-binary :all:; \
fi
WORKDIR /openfl

HEALTHCHECK  --interval=30m --timeout=3s \
  CMD echo "Container works" || exit 1

CMD [ "/bin/bash" ]

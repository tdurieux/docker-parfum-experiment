# Copyright 2017-2022 AVSystem <avsystem@avsystem.com>
# AVSystem Anjay LwM2M SDK
# All rights reserved.
#
# Licensed under the AVSystem-5-clause License.
# See the attached LICENSE file for details.

FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip git build-essential libmbedtls-dev \
    libssl-dev python3 libpython3-dev wget python3-cryptography \
    python3-requests valgrind curl && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e "s/-Wdate-time/ /g" \
    /usr/lib/python3.5/config-3.5m-x86_64-linux-gnu/Makefile \
    /usr/lib/python3.5/plat-x86_64-linux-gnu/_sysconfigdata_m.py
# NOTE: Newer versions depend on syntax new to Python 3.6
RUN pip3 install --no-cache-dir babel==2.9.1 jinja2==2.11.3 markupsafe==1.1.1 packaging==20.9 \
    pygments==2.11.2 sphinx==3.5.4
RUN pip3 install --no-cache-dir sphinx-rtd-theme cmake
# NOTE: We don't install aiocoap as it requires Python 3.5.3 and we have 3.5.2
# NOTE: Newer versions of cbor2 don't install cleanly on Python 3.5
RUN pip3 install --no-cache-dir cbor2==4.1.2

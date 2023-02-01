FROM ubuntu:14.04

RUN set -o xtrace \
    && sed -i 's,^deb-src,# no src # &,; s,http://archive.ubuntu.com/ubuntu/,mirror://mirrors.ubuntu.com/mirrors.txt,' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y apache2-utils curl pv python-tornado && rm -rf /var/lib/apt/lists/*;

RUN set -o xtrace \
    && apt-get install --no-install-recommends -y iperf && rm -rf /var/lib/apt/lists/*;

COPY benchmark.py /benchmark.py

# yandex-tank is nice `ab' replacement, but it's PPA is broken at the moment
# https://github.com/yandex/yandex-tank/issues/202
#
# apt-get install -y software-properties-common
# add-apt-repository ppa:yandex-load/main
# apt-get install -y phantom phantom-ssl yandex-tank

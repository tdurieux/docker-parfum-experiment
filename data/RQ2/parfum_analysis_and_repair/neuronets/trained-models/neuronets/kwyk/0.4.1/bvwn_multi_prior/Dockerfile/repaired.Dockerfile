FROM tensorflow/tensorflow:2.5.0-gpu-jupyter

RUN curl -f -sSL https://neuro.debian.net/lists/bionic.us-nh.full | tee /etc/apt/sources.list.d/neurodebian.sources.list \
  && export GNUPGHOME="$(mktemp -d)" \
  && echo "disable-ipv6" >> ${GNUPGHOME}/dirmngr.conf \
  && apt-key adv --homedir $GNUPGHOME --recv-keys --keyserver hkp://pgpkeys.eu:80 0xA5D32F012649A5A9 \
  && apt-get update \
  && apt-get install --no-install-recommends -y git-annex-standalone git \
  && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*;

RUN git config user.name "nobrainerzoo" \
  && git onfig user.email "nobrainerzoo"

RUN python3 -m pip install --no-cache-dir nobrainer datalad datalad-osf PyYAML

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

WORKDIR "/work"
LABEL maintainer="Jakub Kaczmarzyk <jakub.kaczmarzyk@gmail.com>, Hoda Rajaei <rajaei.hoda@gmail.com>"

ARG base
FROM $base

RUN eval $(cat /etc/lsb-release) && \
    ([ "$DISTRIB_CODENAME" != "xenial" -a "$DISTRIB_CODENAME" != "bionic" ] || \
     ( apt-get update && \
       DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends software-properties-common && \
       add-apt-repository ppa:longsleep/golang-backports ) ) && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      build-essential fakeroot git git-build-recipe gnupg golang \
      libftdi-dev libftdi1-dev libusb-1.0-0-dev \
      packaging-dev pkg-config pbuilder pristine-tar \
      python3 rsync ubuntu-dev-tools wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN chmod 0777 /home

ENV HOME=/home
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/go/bin
ENV DEBFULLNAME="Cesanta Bot"
ENV DEBEMAIL="cesantabot@cesanta.com"
RUN git config --global user.name "Cesanta Bot" && git config --global user.email "cesantabot@cesanta.com"

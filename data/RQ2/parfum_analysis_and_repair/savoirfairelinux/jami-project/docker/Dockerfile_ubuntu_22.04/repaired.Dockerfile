FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get clean
RUN apt-get update && \
    apt-get install --no-install-recommends -y -o Acquire::Retries=10 \
        devscripts \
        equivs \
        python-is-python3 \
        wget && rm -rf /var/lib/apt/lists/*;

ADD scripts/prebuild-package-debian.sh /opt/prebuild-package-debian.sh

COPY packaging/rules/debian-qt/control /tmp/builddeps/debian/control
RUN /opt/prebuild-package-debian.sh qt-deps

COPY packaging/rules/debian/control /tmp/builddeps/debian/control
RUN /opt/prebuild-package-debian.sh jami-deps

ADD scripts/build-package-debian.sh /opt/build-package-debian.sh
CMD ["/opt/build-package-debian.sh"]

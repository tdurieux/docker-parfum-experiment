FROM arm32v7/debian:buster-slim AS build

LABEL maintainer="Dirk Lüth <dirk.lueth@gmail.com>" \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.name="easyepg.minimal"

ARG BUILD_DEPENDENCIES="build-essential cpanminus"
ARG DEPENDENCIES="socat cron iproute2 nano procps phantomjs dialog curl file wget git libxml2-utils perl perl-doc jq php php-curl xml-twig-tools liblocal-lib-perl inetutils-ping zip unzip ca-certificates"

ENV MODE="run" \
    USER_ID="1099" \
    GROUP_ID="1099" \
    TIMEZONE="Europe/Berlin" \
    FREQUENCY="0 2 * * *" \
    UPDATE="yes" \
    REPO="sunsettrack4" \
    BRANCH="master" \
    PACKAGES="" \
    DEBIAN_FRONTEND="noninteractive" \
    TERM=xterm \
    LANGUAGE="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    CURL_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    CLEANUP="/tmp/* /var/tmp/* /var/log/* /var/lib/apt/lists/* /var/lib/{apt,dpkg,cache,log}/ /var/cache/apt/archives /usr/share/doc/ /usr/share/man/ /usr/share/locale/ /root/.cpan /root/.cpanm"

COPY root/qemu-arm-static /usr/bin/
COPY root/entrypoint /usr/local/sbin/entrypoint
COPY root/easyepg.process /usr/local/bin/easyepg.process
COPY root/easyepg.update /usr/local/bin/easyepg.update
COPY root/packages.install /usr/local/sbin/packages.install
COPY root/packages.cleanup /usr/local/sbin/packages.cleanup
COPY root/easyepg.cron /etc/easyepg.cron

RUN apt-get -qy update \
    ### tweak some apt & dpkg settngs
    && echo "APT::Install-Recommends "0";" >> /etc/apt/apt.conf.d/docker-noinstall-recommends \
    && echo "APT::Install-Suggests "0";" >> /etc/apt/apt.conf.d/docker-noinstall-suggests \
    && echo "Dir::Cache "";" >> /etc/apt/apt.conf.d/docker-nocache \
    && echo "Dir::Cache::archives "";" >> /etc/apt/apt.conf.d/docker-nocache \
    && echo "path-exclude=/usr/share/locale/*" >> /etc/dpkg/dpkg.cfg.d/docker-nolocales \
    && echo "path-exclude=/usr/share/man/*" >> /etc/dpkg/dpkg.cfg.d/docker-noman \
    && echo "path-exclude=/usr/share/doc/*" >> /etc/dpkg/dpkg.cfg.d/docker-nodoc \
    && echo "path-include=/usr/share/doc/*/copyright" >> /etc/dpkg/dpkg.cfg.d/docker-nodoc \
    ### install basic packages \
    && apt-get install --no-install-recommends -qy apt-utils locales tzdata \
    ### limit locale to en_US.UTF-8
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen --purge en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    ### run dist-upgrade
    && apt-get dist-upgrade -qy \
    ### install easyepg dependencies
    && apt-get install --no-install-recommends -qy ${BUILD_DEPENDENCIES} ${DEPENDENCIES} \
    ### install cpan modules
    && cpan -T App:cpanminus \
    && cpanm install -n utf8 \
    && cpanm install -n JSON \
    && cpanm install -n XML::Rules \
    && cpanm install -n XML::DOM \
    && cpanm install -n Data::Dumper \
    && cpanm install -n Time::Piece \
    && cpanm install -n Time::Seconds \
    && cpanm install -n DateTime \
    && cpanm install -n DateTime::Format::DateParse \
    && cpanm install -n DateTime::Format::Strptime \
    ### create necessary files/directories
    && mkdir -p /easyepg \
    && touch /xmltv.sock \
    ### alter permissions
    && chmod +x /usr/local/sbin/entrypoint \
    && chmod +x /usr/local/bin/easyepg.process \
    && chmod +x /usr/local/bin/easyepg.update \
    && chmod +x /usr/local/sbin/packages.install \
    && chmod +x /usr/local/sbin/packages.cleanup \
    && chmod 644 /etc/easyepg.cron \
    ### cleanup
    && apt-get remove --purge -qy ${BUILD_DEPENDENCIES} \
    && /usr/local/sbin/packages.cleanup && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "/usr/local/sbin/entrypoint" ]

VOLUME /easyepg

FROM build

RUN rm -rf /usr/bin/qemu-*

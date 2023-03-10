FROM multiarch/debian-debootstrap:armhf-buster-slim as base

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-transport-https ca-certificates dirmngr gnupg && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo 'deb https://download.mono-project.com/repo/debian stable-stretch main' | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get remove --purge --autoremove -y gnupg dirmngr && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl ca-certificates iputils-ping sqlite3 \
        mono-runtime \
        cli-common \
        binfmt-support \
        ca-certificates-mono \
        libmono-sqlite4.0-cil \
        libmono-system2.0-cil \
        libmono-system4.0-cil \
        libmono-security4.0-cil \
        libmono-windowsbase4.0-cil \
        libmono-system-componentmodel-dataannotations4.0-cil \
        libmono-system-core4.0-cil \
        libmono-system-configuration4.0-cil \
        libmono-system-data4.0-cil \
        libmono-system-data-datasetextensions4.0-cil \
        libmono-system-deployment4.0-cil \
        libmono-system-design4.0-cil \
        libmono-system-drawing4.0-cil \
        libmono-system-enterpriseservices4.0-cil \
        libmono-system-io-compression4.0-cil \
        libmono-system-net4.0-cil \
        libmono-system-net-http4.0-cil \
        libmono-system-runtime4.0-cil \
        libmono-system-runtime-serialization4.0-cil \
        libmono-system-security4.0-cil \
        libmono-system-servicemodel4.0a-cil \
        libmono-system-servicemodel-web4.0-cil \
        libmono-system-transactions4.0-cil \
        libmono-system-web4.0-cil \
        libmono-system-web-services4.0-cil \
        libmono-system-windows4.0-cil \
        libmono-system-windows-forms4.0-cil \
        libmono-system-xml4.0-cil \
        libmono-system-xml-linq4.0-cil \
        libmono-system-xml-serialization4.0-cil && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

FROM base as builder

ARG VIRTUALRADAR_HASH
ARG VIRTUALRADAR_WEBADMINPLUGIN_HASH

RUN curl -f --output VirtualRadar.tar.gz -L "https://www.virtualradarserver.co.uk/Files/VirtualRadar.tar.gz" && \
    sha256sum VirtualRadar.tar.gz && echo "${VIRTUALRADAR_HASH}  VirtualRadar.tar.gz" | sha256sum -c
RUN curl -f --output VirtualRadar.WebAdminPlugin.tar.gz -L "https://www.virtualradarserver.co.uk/Files/VirtualRadar.WebAdminPlugin.tar.gz" && \
    sha256sum VirtualRadar.WebAdminPlugin.tar.gz && echo "${VIRTUALRADAR_WEBADMINPLUGIN_HASH}  VirtualRadar.WebAdminPlugin.tar.gz" | sha256sum -c

RUN mkdir vrs && cd vrs && \
    tar -xvf ../VirtualRadar.tar.gz --strip-components=0 && \
    tar -xvf ../VirtualRadar.WebAdminPlugin.tar.gz --strip-components=0 && rm ../VirtualRadar.tar.gz

COPY VirtualRadar.exe.config /vrs/VirtualRadar.exe.config

FROM base

COPY --from=builder /vrs /opt/vrs

COPY InstallerConfiguration.xml /root/.local/share/VirtualRadar/InstallerConfiguration.xml
COPY Configuration.xml /root/.local/share/VirtualRadar/Configuration.xml
COPY vrs-runner.sh /usr/local/bin/vrs-runner

EXPOSE 30053

HEALTHCHECK --start-period=1m --interval=30s --timeout=5s --retries=3 CMD curl --fail http://localhost:8080/VirtualRadar/ || exit 1

ENTRYPOINT ["vrs-runner"]

# Metadata
ARG VCS_REF="Unknown"
LABEL maintainer="thebigguy.co.uk@gmail.com" \
      org.label-schema.name="Docker ADS-B - VirtualRadar" \
      org.label-schema.description="Docker container for ADS-B - This is the virtualradarserver.co.uk component" \
      org.label-schema.url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/TheBiggerGuy/docker-ads-b" \
      org.label-schema.schema-version="1.0"

ARG BASE_IMAGE

FROM ${BASE_IMAGE} as builder

USER root

# install
RUN apt-get -y update \
    && apt-get -y --no-install-recommends --allow-unauthenticated install unzip \
    && wget -progress=bar:force -q -O sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2113331 \
    && unzip -qq sqlpackage.zip -d /opt/sqlpackage \
    && chmod +x /opt/sqlpackage/sqlpackage && rm -rf /var/lib/apt/lists/*;

# copy solution dacpac
COPY docker/images/demo-sqldev/data/ /opt/src/data/
COPY docker/images/demo-sqldev/install-databases.sh /opt

# install solution dacpac
ENV DB_PREFIX='sc'

RUN mkdir -p /install \
    && chmod -R 700 /install \
    && cp /clean/* /install/ \
    && ( /opt/mssql/bin/sqlservr & ) | grep -q "Service Broker manager has started" \
    && chmod +x /opt/attach-databases.sh \
	&& chmod +x /opt/install-databases.sh \
	&& /opt/attach-databases.sh /install \
    && /opt/install-databases.sh /opt/src/data/data \
    && /opt/install-databases.sh /opt/src/data/descendants

FROM $BASE_IMAGE as production

USER root

ENV USER_PASSWORD="b"
ENV SITECORE_ADMIN_PASSWORD="b"
ENV ADMIN_USER_NAME="sitecore\superuser"
ENV DISABLE_DEFAULT_ADMIN=FALSE
ENV EXM_BASE_URL=http://cd
ENV EXM_KIOSK_CD_BASE_URL=http://kiosk-cd
ENV EXM_APP_BASE_URL=http://app
ENV BOOT_OVERRIDE_SCRIPTS="Demo-Boot-Platform-Linux.ps1;Demo-Boot-Headless-Linux.ps1"

COPY --from=builder ["/install/*", "/clean/"]

# start-up scripts for demo
COPY /docker/images/demo-sqldev/sql /sql
COPY /docker/images/demo-sqldev/Demo-Boot-Headless-Linux.ps1 /opt
COPY /docker/images/demo-sqldev/Demo-Boot-Omni-Linux.ps1 /opt

RUN chmod +x /opt/Demo-Boot-Headless-Linux.ps1
RUN chmod +x /opt/Demo-Boot-Omni-Linux.ps1

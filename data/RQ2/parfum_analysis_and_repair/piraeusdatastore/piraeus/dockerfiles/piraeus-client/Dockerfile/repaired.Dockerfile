ARG DISTRO=bullseye
FROM debian:$DISTRO

MAINTAINER Roland Kammerer <roland.kammerer@linbit.com>

ARG LINSTOR_CLIENT_VERSION
ARG PYTHON_LINSTOR_VERSION
ARG DISTRO

RUN { echo 'APT::Install-Recommends "false";' ; echo 'APT::Install-Suggests "false";' ; } > /etc/apt/apt.conf.d/99_piraeus
RUN apt-get update && apt-get install --no-install-recommends -y wget ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnupg2 && \
    wget -O- https://packages.linbit.com/package-signing-pubkey.asc | gpg --batch --dearmor > /etc/apt/trusted.gpg.d/linbit-keyring.gpg && \
    echo "deb http://packages.linbit.com/public" $DISTRO "misc" > /etc/apt/sources.list.d/linbit.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y linstor-client=$LINSTOR_CLIENT_VERSION python-linstor=$PYTHON_LINSTOR_VERSION && \
    apt-get autoremove -y gnupg2 && apt-get clean && rm -rf /var/lib/apt/lists/*;
# candidates for squashing:
#	 && rm -rf /usr/share/doc /usr/share/man /var/cache/debconf /usr/share/locale /usr/bin/perl

ENTRYPOINT ["linstor"]

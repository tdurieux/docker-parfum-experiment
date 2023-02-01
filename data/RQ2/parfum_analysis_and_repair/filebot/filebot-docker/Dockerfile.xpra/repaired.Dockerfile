FROM rednoah/filebot

LABEL maintainer="Reinhard Pointner <rednoah@filebot.net>"


RUN set -eux \
 && apt-key adv --fetch-keys "https://xpra.org/gpg.asc" \
 && curl -f -o "/etc/apt/sources.list.d/xpra.list" "https://xpra.org/repos/focal/xpra.list" \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y xpra default-jre zenity \
 && mkdir -m 777 -p /tmp/xdg/xpra \
 && ln -sf /usr/lib/xpra/xdg-open /usr/bin/xdg-open \
 && rm -rvf /usr/share/xpra/www/default-settings.* \
 && rm -rvf /var/lib/apt/lists/*

# install custom launcher scripts
COPY xpra /


ENV XPRA_BIND 0.0.0.0
ENV XPRA_PORT 5454
ENV XPRA_AUTH none


EXPOSE $XPRA_PORT

ENTRYPOINT ["/opt/bin/run-as-user", "/opt/filebot-xpra/start"]

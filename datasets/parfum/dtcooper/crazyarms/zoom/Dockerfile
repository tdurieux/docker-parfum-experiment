# Seems like Zoom works properly under QEMU for testing/development with `liunux/amd64`
# emulation on on Apple M1 (linux/arm64/v8). Chrome doesn't, but that's fine.
FROM --platform=linux/amd64 ubuntu:20.04

ENV DISPLAY=:0

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        icewm \
        libxkbcommon-x11-0 \
        netcat \
        psmisc \
        pulseaudio \
        redis-tools \
        sudo \
        supervisor \
        websockify \
        wget \
        xdotool \
        x11vnc \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO /tmp/zoom.deb https://zoom.us/client/latest/zoom_amd64.deb \
    && wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        /tmp/zoom.deb \
        google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* /tmp/*.deb \
    && adduser --gecos '' --disabled-password user

RUN rmdir /etc/supervisor/conf.d && ln -s /config/zoom/supervisor /etc/supervisor/conf.d

COPY image/ /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

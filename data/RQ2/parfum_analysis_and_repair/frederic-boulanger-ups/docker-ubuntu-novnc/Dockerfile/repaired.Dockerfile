################################################################################
# base system
################################################################################

FROM ubuntu:20.04 as system

#RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

# Avoid prompts for time zone
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Paris
# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1

# built-in packages
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends apt-utils -y \
    && apt-get install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor nginx sudo net-tools zenity xz-utils \
        dbus-x11 x11-utils alsa-utils \
        mesa-utils libgl1-mesa-dri wget && rm -rf /var/lib/apt/lists/*;

# install debs error if combine together
RUN apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        xvfb x11vnc \
        vim-tiny ttf-ubuntu-font-family ttf-wqy-zenhei && rm -rf /var/lib/apt/lists/*;

# Alternative VNC server
# RUN apt-get install -y tigervnc-scraping-server

# RUN apt-get update \
#     && apt-get install -y gpg-agent \
#     && curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
#     && (dpkg -i ./google-chrome-stable_current_amd64.deb || apt-get install -fy) \
#     && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add \
#     && rm google-chrome-stable_current_amd64.deb \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme && rm -rf /var/lib/apt/lists/*;


RUN apt-get update && apt-get install --no-install-recommends -y python3 python3-tk gcc make cmake && rm -rf /var/lib/apt/lists/*;

# tini to fix subreap
ARG TINI_VERSION=v0.19.0
RUN wget https://github.com/krallin/tini/archive/v0.19.0.tar.gz \
 && tar zxf v0.19.0.tar.gz \
 && export CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"; \
    cd tini-0.19.0; cmake . && make && make install \
 && cd ..; rm -r tini-0.19.0 v0.19.0.tar.gz

#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
#RUN chmod +x /bin/tini

# ffmpeg
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends --allow-unauthenticated \
#         ffmpeg \
#     && rm -rf /var/lib/apt/lists/* \
#     && mkdir /usr/local/ffmpeg \
#     && ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/ffmpeg

# NextCloud
RUN apt-get update && apt-get install --no-install-recommends -y nextcloud-desktop && rm -rf /var/lib/apt/lists/*;

# Firefox
RUN apt-get update && apt-get install --no-install-recommends -y firefox libpci3 && rm -rf /var/lib/apt/lists/*;

# Killsession app
COPY killsession/ /tmp/killsession
RUN cd /tmp/killsession; \
    gcc -o killsession killsession.c && \
    mv killsession /usr/local/bin && \
    chmod a=rx /usr/local/bin/killsession && \
    chmod a+s /usr/local/bin/killsession && \
    mv killsession.py /usr/local/bin/ && chmod a+x /usr/local/bin/killsession.py && \
    mkdir -p /usr/local/share/pixmaps && mv killsession.png /usr/local/share/pixmaps/ && \
    mv KillSession.desktop /usr/share/applications/ && chmod a+x /usr/share/applications/KillSession.desktop && \
    cd /tmp && rm -r killsession


# python library
COPY rootfs/usr/local/lib/web/backend/requirements.txt /tmp/
RUN apt-get update \
    && dpkg-query -W -f='${Package}\n' > /tmp/a.txt \
    && apt-get install --no-install-recommends -y python3-pip python3-dev build-essential \
    && pip3 install --no-cache-dir setuptools wheel && pip3 install --no-cache-dir -r /tmp/requirements.txt \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && dpkg-query -W -f='${Package}\n' > /tmp/b.txt \
    && apt-get remove -y `diff --changed-group-format='%>' --unchanged-group-format='' /tmp/a.txt /tmp/b.txt | xargs` \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* /tmp/a.txt /tmp/b.txt

RUN apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

################################################################################
# builder
################################################################################
FROM ubuntu:20.04 as builder

#RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg patch && rm -rf /var/lib/apt/lists/*;

# nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# yarn
# Fix issue with libssl and docker on M1 chips
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
COPY yarnpkg_pubkey.gpg .
RUN cat yarnpkg_pubkey.gpg | apt-key add -  && rm yarnpkg_pubkey.gpg \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# build frontend
COPY web /src/web
RUN cd /src/web \
    && yarn upgrade \
    && yarn \
    && yarn build && yarn cache clean;
RUN sed -i 's#app/locale/#novnc/app/locale/#' /src/web/dist/static/novnc/app/ui.js

RUN apt autoremove && apt autoclean

################################################################################
# merge
################################################################################
FROM system
LABEL maintainer="frederic.boulanger@centralesupelec.fr"

COPY --from=builder /src/web/dist/ /usr/local/lib/web/frontend/
COPY rootfs /
RUN ln -sf /usr/local/lib/web/frontend/static/websockify /usr/local/lib/web/frontend/static/novnc/utils/websockify && \
	chmod +x /usr/local/lib/web/frontend/static/websockify/run

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]

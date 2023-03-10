# Built with arch: {{ arch }} flavor: {{ flavor }} image: {{ image }} localbuild: {{localbuild }}
#
################################################################################
# base system
################################################################################
{%if arch == "amd64"%}
FROM {{image}} as system
{%elif arch == "armhf"%}
# qemu helper for arm build
FROM {{image}} as amd64
RUN apt update && apt install --no-install-recommends -y qemu-user-static && rm -rf /var/lib/apt/lists/*;
FROM arm32v7/{{image}} as system
COPY --from=amd64 /usr/bin/qemu-arm-static /usr/bin/
{%endif%}

{% if localbuild == 1 %}
RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list;
{% endif %}

# built-in packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        supervisor nginx sudo net-tools zenity xz-utils \
        dbus-x11 x11-utils alsa-utils \
        mesa-utils libgl1-mesa-dri \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
# install debs error if combine together
RUN add-apt-repository -y ppa:fcwu-tw/apps \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        xvfb x11vnc=0.9.16-1 \
        {%for package in addon_packages%}{{package}} {%endfor%} \
    && add-apt-repository -r ppa:fcwu-tw/apps \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
{%if desktop == "lxde" %}
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
{%endif%}
{%if desktop == "lxqt" %}
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        lxqt openbox gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
{%endif%}
{%if desktop == "xfce4" %}
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        xubuntu-desktop \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
{%endif%}
# Additional packages require ~600MB
# libreoffice  pinta language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant libreoffice-l10n-zh-tw

# tini for subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-{{arch}} /bin/tini
RUN chmod +x /bin/tini

# ffmpeg
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /usr/local/ffmpeg \
    && ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/ffmpeg


# python library
COPY image/usr/local/lib/web/backend/requirements.txt /tmp/
RUN apt-get update \
    && dpkg-query -W -f='${Package}\n' > /tmp/a.txt \
    && apt-get install --no-install-recommends -y python-pip python-dev build-essential \
	&& pip install --no-cache-dir setuptools wheel && pip install --no-cache-dir -r /tmp/requirements.txt \
    && dpkg-query -W -f='${Package}\n' > /tmp/b.txt \
    && apt-get remove -y `diff --changed-group-format='%>' --unchanged-group-format='' /tmp/a.txt /tmp/b.txt | xargs` \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* /tmp/a.txt /tmp/b.txt


################################################################################
# builder
################################################################################
FROM {{image}} as builder

{% if localbuild == 1 %}
RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list;
{% endif %}

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg patch && rm -rf /var/lib/apt/lists/*;

# nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# build frontend
COPY web /src/web
RUN cd /src/web \
    && yarn \
    && npm run build

{%if arch == "armhf"%}
RUN cd /src/web/dist/static/novnc && patch -p0 < /src/web/novnc-armhf-1.patch
{%endif%}

################################################################################
# merge
################################################################################
FROM system
LABEL maintainer="fcwu.tw@gmail.com"

COPY --from=builder /src/web/dist/ /usr/local/lib/web/frontend/
COPY image /

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]

# Supported base images: ubuntu:20.04, ubuntu:18.04
ARG UBUNTU_RELEASE=20.04
ARG GSTREAMER_BASE_IMAGE=ghcr.io/selkies-project/selkies-gstreamer/gstreamer
ARG GSTREAMER_BASE_IMAGE_RELEASE=latest
ARG PY_BUILD_IMAGE=ghcr.io/selkies-project/selkies-gstreamer/py-build:latest
ARG WEB_IMAGE=ghcr.io/selkies-project/selkies-gstreamer/gst-web:latest
FROM ${GSTREAMER_BASE_IMAGE}:${GSTREAMER_BASE_IMAGE_RELEASE}-ubuntu${UBUNTU_RELEASE} as selkies-gstreamer
FROM ${PY_BUILD_IMAGE} as selkies-build
FROM ${WEB_IMAGE} as selkies-web
FROM ubuntu:${UBUNTU_RELEASE}

LABEL maintainer "https://github.com/danisla"

# Install Selkies GStreamer system dependencies
RUN \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        build-essential \
        python3-pip \
        python3-dev \
        python3-gi \
        python3-setuptools \
        python3-wheel \
        tzdata \
        sudo \
        udev \
        xclip \
        x11-utils \
        xdotool \
        wmctrl \
        jq \
        gdebi-core \
        x11-xserver-utils \
        xserver-xorg-core \
        libopus0 \
        libgdk-pixbuf2.0-0 \
        libsrtp2-1 \
        libxdamage1 \
        libxml2-dev \
        libwebrtc-audio-processing1 \
        libcairo-gobject2 \
        pulseaudio \
        libpulse0 \
        libpangocairo-1.0-0 \
        libgirepository1.0-dev \
        libjpeg-dev \
        zlib1g-dev \
        x264 \
        git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Install test dependencies
RUN \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        vim \
        curl \
        jq \
        xvfb \
        xfce4 \
        xfce4-terminal \
        adwaita-icon-theme-full \
        dbus-x11 \
        x11-apps \
        firefox && \
    rm -rf /var/lib/apt/lists/*

# Add Tini init script - take care of runaway processes
ENV TINI_VERSION v0.7.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Install gstreamer distribution
COPY --from=selkies-gstreamer /opt/gstreamer ./gstreamer

# Install web app
COPY --from=selkies-web /usr/share/nginx/html ./gst-web

# Update PWA manifest.json with app info and route.
ARG PWA_APP_NAME="Selkies WebRTC"
ARG PWA_APP_SHORT_NAME="selkies"
ARG PWA_START_URL="/index.html"
RUN \
    sed -i \
        -e "s|PWA_APP_NAME|${PWA_APP_NAME}|g" \
        -e "s|PWA_APP_SHORT_NAME|${PWA_APP_SHORT_NAME}|g" \
        -e "s|PWA_START_URL|${PWA_START_URL}|g" \
    /opt/gst-web/manifest.json && \
    sed -i \
        -e "s|PWA_CACHE|${PWA_APP_SHORT_NAME}-webrtc-pwa|g" \
    /opt/gst-web/sw.js

# Install selkies-gstreamer python app
ARG PYPI_PACKAGE=selkies_gstreamer
ARG PACKAGE_VERSION=1.0.0.dev0
COPY --from=selkies-build /opt/pypi/dist/${PYPI_PACKAGE}-${PACKAGE_VERSION}-py3-none-any.whl .
RUN pip3 install --no-cache-dir /opt/${PYPI_PACKAGE}-${PACKAGE_VERSION}-py3-none-any.whl

# TODO: required for remote-cursor support.
# Remove this and uncommend line in setup.cfg after this PR is merged and in release:
# https://github.com/python-xlib/python-xlib/pull/218
RUN pip3 install --no-cache-dir -e git+https://github.com/selkies-project/python-xlib.git@add-xfixes-cursor#egg=python-xlib

# Setup global bashrc to configure gstreamer environment
RUN echo 'export DISPLAY=:0' \
        >> /etc/bash.bashrc && \
    echo 'export GST_DEBUG=*:2' \
        >> /etc/bash.bashrc && \
    echo 'source /opt/gstreamer/gst-env' \
        >> /etc/bash.bashrc

# Write startup script
RUN echo "#!/bin/bash\n\
export DISPLAY=:0\n\
export GST_DEBUG=*:2\n\
export PULSE_SERVER=127.0.0.1:4713\n\
source /opt/gstreamer/gst-env\n\
Xvfb -screen :0 8192x4096x24 +extension RANDR +extension GLX +extension MIT-SHM -nolisten tcp -noreset -shmem 2>&1 >/tmp/Xvfb.log &\n\
until [[ -S /tmp/.X11-unix/X0 ]]; do sleep 1; done && echo 'X Server is ready'\n\
sudo /usr/bin/pulseaudio -k >/dev/null 2>&1\n\
sudo /usr/bin/pulseaudio --daemonize --system --verbose --log-target=file:/tmp/pulseaudio.log --realtime=true --disallow-exit -L 'module-native-protocol-tcp auth-ip-acl=127.0.0.0/8 port=4713 auth-anonymous=1'\n\
[[ \${START_XFCE4:-true} == true ]] && xfce4-session &\n\
export WEBRTC_ENCODER=\${WEBRTC_ENCODER:-x264enc}\n\
export WEBRTC_ENABLE_RESIZE=\${WEBRTC_ENABLE_RESIZE:-true}\n\
export JSON_CONFIG=/tmp/selkies.json\n\
echo '{}' > \$JSON_CONFIG\n\
selkies-gstreamer-resize 1280x720\n\
selkies-gstreamer\n\
" > /entrypoint.sh && chmod +x /entrypoint.sh

# Configure bashrc to show /etc/motd and /etc/issue
RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' \
    >> /etc/bash.bashrc \
    ; echo "\
===================================================================\n\
= Selkies GStreamer test Docker container                         =\n\
===================================================================\n\
\n\
To test the package:\n\
\n\
/entrypoint.sh\n\
\n\
Or start each process separately:\n\
\n\
$(tail -n +2 /entrypoint.sh)\n\
\n\
To test the signaling server standalone:\n\
\n\
python3 signalling_web.py --disable-ssl --port 8080 --web_root=/opt/gst-web &\n\
\n\
"\
    > /etc/motd

# Add login user
ARG TZ=UTC
ARG PASSWD=mypasswd
RUN groupadd -g 1000 user && \
    useradd -ms /bin/bash user -u 1000 -g 1000 && \
    usermod -a -G adm,audio,cdrom,dialout,dip,fax,floppy,input,plugdev,sudo,tape,tty,video,voice user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R user:user /home/user && \
    echo "user:${PASSWD}" | chpasswd && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

USER user
RUN touch ${HOME}/.sudo_as_admin_successful

# Set default icewm theme
RUN mkdir -p ${HOME}/.icewm && echo 'Theme="NanoBlue/default.theme"' > ${HOME}/.icewm/theme

WORKDIR /usr/local/lib/python3.8/dist-packages/selkies_gstreamer

ENTRYPOINT ["/tini", "--"]
CMD ["/entrypoint.sh"]

FROM base

RUN apt-add-repository -y ppa:saiarcot895/chromium-dev && apt-get update
RUN apt-get install --no-install-recommends -y x11-xkb-utils x11-xserver-utils alsa-utils fonts-takao fonts-wqy-zenhei openbox firefox thunderbird gajim transmission-gtk gstreamer1.0-libav gstreamer1.0-plugins-good chromium-browser gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

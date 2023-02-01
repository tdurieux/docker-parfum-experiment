FROM ubuntu:16.04
MAINTAINER info@openvidu.io

ARG CHROME_VERSION

# Install Chrome
RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y wget sudo \

  ttf-ancient-fonts fonts-beng fonts-wqy-zenhei fonts-indic && rm -rf /var/lib/apt/lists/*;

RUN wget https://dl.google.com/linux/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
  && apt install --no-install-recommends -y ./google-chrome-stable_${CHROME_VERSION}_amd64.deb \
  && rm google-chrome-stable_${CHROME_VERSION}_amd64.deb \
  && google-chrome --version && rm -rf /var/lib/apt/lists/*;

# Install media packages
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:jonathonf/ffmpeg-4
RUN apt-get update
RUN apt-get install --no-install-recommends -y ffmpeg pulseaudio xvfb && rm -rf /var/lib/apt/lists/*;

# Install jq for managing JSON
RUN apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

# Add root user to pulseaudio group
RUN adduser root pulse-access

# Clean
RUN apt-get autoclean

COPY entrypoint.sh scripts/composed.sh scripts/composed_quick_start.sh ./
COPY utils/xvfb-run-safe /usr/local/bin

# Prepare scripts and folders
RUN chmod +x /entrypoint.sh /composed.sh /composed_quick_start.sh \
  && chmod +x /usr/local/bin/xvfb-run-safe \
  && mkdir /recordings \
  && chmod 777 /recordings

ENTRYPOINT /entrypoint.sh

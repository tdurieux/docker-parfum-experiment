FROM node:lts-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --no-install-recommends \
 && apt-get install --no-install-recommends -y \
    build-essential \
    bzip2 \
    ca-certificates \
    dbus \
    jq \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo-gobject2 \
    libcairo2 \
    libdbus-1-3 \
    libdbus-glib-1-2 \
    libfontconfig1 \
    libfreetype6 \
    libgbm-dev \
    libgbm1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libgtk2.0-0 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstartup-notification0 \
    libstdc++6 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxml2-utils \
    libxrender1 \
    libxt6 \
    lsb-release \
    menu \
    openbox \
    python-dev \
    python-pip \
    unzip \
    wget \
    x11vnc \
    xauth \
    xvfb \
    zip \
 && rm -rf /var/lib/apt/lists/*

ENV PATH "/usr/local/ssl/bin:$PATH"

RUN mkdir /app
RUN chown node:node -R /app

# Prevent errors when running xvfb as node user
RUN mkdir /tmp/.X11-unix \
 && chmod 1777 /tmp/.X11-unix \
 && chown root /tmp/.X11-unix

# Expose port for VNC
EXPOSE 5900

USER node

# Install Firefox beta
RUN wget 'https://download.mozilla.org/?product=firefox-devedition-latest&os=linux64&lang=en-US' -O /home/node/firefox.tar.bz2 \
 && mkdir /home/node/firefoxBeta \
 && tar xjvf /home/node/firefox.tar.bz2 -C /home/node/firefoxBeta \
 && rm -f /home/node/firefox.tar.bz2

COPY --chown=node:node package.json /app/
COPY --chown=node:node package-lock.json /app/

WORKDIR /app/

RUN npm ci

FROM gitpod/workspace-full

USER root
RUN sudo apt-get update && apt-get install --no-install-recommends -y apt-transport-https \
 && sudo apt-get install --no-install-recommends -y \
    xserver-xorg-dev \
    libxext-dev \
    build-essential \
    libxi-dev \
    libglew-dev \
    pkg-config \
    libglu1-mesa-dev \
    freeglut3-dev \
    mesa-common-dev \
    x11-apps x11-apps \
    libice6 \
    libsm6 \
    libxaw7 \
    libxft2 \
    libxmu6 \
    libxpm4 \
    libxt6 \

    xbitmaps \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    wget \
    xdg-utils \
    xvfb x11-apps \







































 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

USER gitpod

RUN bash -c ". ~/.nvm/nvm-lazy.sh && npm install -g gulp-cli live-server"

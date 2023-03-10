FROM kalilinux/kali-rolling

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt upgrade -y && apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    coreutils \
    bash \
    nodejs \
    bzip2 \
    curl \
    figlet \
    gcc \
    g++ \
    git \
    util-linux \
    libevent-dev \
    libjpeg-dev \
    libffi-dev \
    libpq-dev \
    libwebp-dev \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    musl \
    neofetch \
    libcurl4-openssl-dev \
    postgresql \
    postgresql-client \
    postgresql-server-dev-all \
    openssl \
    mediainfo \
    wget \
    python3 \
    python3-dev \
    python3-pip \
    libreadline-dev \
    zipalign \
    sqlite3 \
    ffmpeg \
    libsqlite3-dev \
    zlib1g-dev \
    recoverjpeg \
    zip \
    unrar \
    megatools \
    libfreetype6-dev \
    procps \
    policykit-1 \
    p7zip-full \
    tree && rm -rf /var/lib/apt/lists/*;

RUN apt-get autoremove --purge

RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
RUN if [ ! -e /usr/bin/python ]; then ln -sf /usr/bin/python3 /usr/bin/python; fi
RUN rm -r /root/.cache
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb && rm google-chrome-stable_current_amd64.deb && rm -rf /var/lib/apt/lists/*;
RUN wget https://chromedriver.storage.googleapis.com/88.0.4324.96/chromedriver_linux64.zip && unzip chromedriver_linux64.zip && chmod +x chromedriver && mv -f chromedriver /usr/bin/ && rm chromedriver_linux64.zip
RUN git clone https://github.com/Thundergang/thunderuserbot /root/thunderbot
RUN mkdir /root/thunderbot/bin/
WORKDIR /root/thunderbot/
RUN chmod +x /usr/local/bin/*
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["bash","./Extras/startup.sh"]

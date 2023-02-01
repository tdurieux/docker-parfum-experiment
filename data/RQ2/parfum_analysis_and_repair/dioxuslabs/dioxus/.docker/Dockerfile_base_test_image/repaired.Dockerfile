FROM rust:1.58-buster

RUN apt update && apt install --no-install-recommends -y \
    libglib2.0-dev \
    libgtk-3-dev \
    libsoup2.4-dev \
    libappindicator3-dev \
    libwebkit2gtk-4.0-dev \
    firefox-esr \

    liblzma-dev binutils-dev libcurl4-openssl-dev libdw-dev libelf-dev && rm -rf /var/lib/apt/lists/*;

CMD ["exit"]

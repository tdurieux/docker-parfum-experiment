FROM linuxmintd/mint19.1-amd64:latest
LABEL maintainer="developers@moneymanagerex.org"
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      ccache \
      cmake \
      gettext \
      git \
      libcurl4-openssl-dev \
      liblua5.3-dev \
      libwxgtk-webview3.0-gtk3-dev \
      lsb-release \
      pkg-config \
      rapidjson-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV MMEX_INST_CMD apt-get update && apt install -yqV ./mmex_*.deb
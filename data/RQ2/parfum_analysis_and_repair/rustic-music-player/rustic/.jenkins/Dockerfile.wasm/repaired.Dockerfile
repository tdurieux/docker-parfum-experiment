FROM rust:buster

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt update && apt upgrade -y && apt install --no-install-recommends -y libasound2-dev cmake libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev libdbus-1-dev dbus qtbase5-dev qtdeclarative5-dev nodejs && rm -rf /var/lib/apt/lists/*;

RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

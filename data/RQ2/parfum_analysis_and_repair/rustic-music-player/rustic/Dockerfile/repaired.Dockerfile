FROM rust:buster

RUN apt update && apt upgrade -y && apt install --no-install-recommends -y libasound2-dev cmake libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev libdbus-1-dev dbus qtbase5-dev qtdeclarative5-dev libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /src

COPY ./ /src/

RUN cargo build --release

ENTRYPOINT /src/target/release/rustic

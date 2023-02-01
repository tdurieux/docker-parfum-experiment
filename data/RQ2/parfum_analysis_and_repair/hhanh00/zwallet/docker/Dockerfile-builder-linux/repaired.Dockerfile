FROM ubuntu

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq curl && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
RUN apt-get update
RUN apt-get install --no-install-recommends -yq unzip xz-utils clang cmake git ninja-build pkg-config libgtk-3-dev liblzma-dev libgstreamer-plugins-base1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.3-stable.tar.xz
RUN tar xvf flutter.tar.xz && rm flutter.tar.xz
RUN rm -f flutter.tar.xz


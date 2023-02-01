FROM almalinux:8

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.61.0

RUN set -eux; \
    dnf check-update && dnf update -y ; \
    dnf install -y curl epel-release cmake gcc make dnf-plugins-core; \
    yum config-manager --set-enabled powertools ; \
    dnf install -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm ; \
    dnf install -y https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm ; \
    dnf -y update ; \
    dnf install -y alsa-lib-devel \
     libxcb-devel \
     dbus-devel \
     clang-devel \
     krb5-devel \
     ffmpeg-devel \
     opus-devel \
     libavdevice \
     pam-devel \
     python3; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path ; \
    cargo install cargo-generate-rpm ;


WORKDIR /SRC
CMD cargo build $CARGO_OPT ; cargo generate-rpm $CARGORPM_OPT
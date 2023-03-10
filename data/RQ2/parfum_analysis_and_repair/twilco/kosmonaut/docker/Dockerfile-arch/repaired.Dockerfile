FROM archlinux:20200705
RUN pacman -Syu --noconfirm curl git base-devel cmake pkg-config freetype2 expat
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly
ENV PATH="/root/.cargo/bin:${PATH}"
RUN git clone https://github.com/twilco/kosmonaut.git
WORKDIR kosmonaut
RUN cargo build
FROM archlinux:base-devel

ENV PKG_CONFIG_ALLOW_CROSS=1 \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.61.0

RUN set -eux; \
    pacman -Syu --noconfirm ; \
    pacman -S --noconfirm \
      pkgconf \
      clang \
      gcc \
      cmake \
      llvm \
      nasm \
      mingw-w64-binutils \
      mingw-w64-gcc \
      mingw-w64-crt \
      zip \
      p7zip \
      unzip \
      sudo \
      git \
      fakeroot; \
    useradd -ms /bin/bash builduser ; \
    passwd -d builduser ; \
    printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers ; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path ; \
    rustup target add x86_64-pc-windows-gnu ; \
    rustup toolchain install stable-x86_64-pc-windows-gnu ; \
    for lib in SECUR32 KERNEL32 OLEAUT32 OLE32 ; do ln -s /usr/x86_64-w64-mingw32/lib/lib${lib,,}.a /usr/x86_64-w64-mingw32/lib/lib${lib}.a ; done ; \
    pacman -S --noconfirm \
      libxtst \
      libxext \
      ffmpeg \
      libxdamage \
      libxfixes \
      curl ; \      
    cd /tmp/ ; \
    curl -L -o /tmp/ffmpeg.zip https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-n5.0-latest-win64-gpl-shared-5.0.zip ; \
    unzip /tmp/ffmpeg.zip ; cd /tmp/ffmpeg*/bin/ ; \
    for lib in *.dll ; do echo ${lib} ; \
        cp $lib /usr/x86_64-w64-mingw32/lib/${lib} ; \
        ln -s /usr/x86_64-w64-mingw32/lib/${lib} /usr/x86_64-w64-mingw32/lib/${lib/-*.dll/.dll} ; \
    done; \
    cd /tmp ; \
    sudo --preserve-env=https_proxy -u builduser bash -c 'git clone https://aur.archlinux.org/aurman.git ; cd aurman ; \
            makepkg --skippgpcheck --noconfirm -si' ;  \
    sudo --preserve-env=https_proxy --preserve-env=http_proxy -u builduser bash -c 'aurman --noconfirm  --skip_news --noedit -S mingw-w64-opus' ;


WORKDIR /SRC
CMD cargo build --target x86_64-pc-windows-gnu $CARGO_OPT
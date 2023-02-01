FROM dyne/devuan:chimaera

RUN echo "deb http://deb.devuan.org/merged chimaera main" >> /etc/apt/sources.list
RUN apt-get update -y -q --allow-releaseinfo-change && apt-get install --no-install-recommends -y -q zsh cryptsetup gpg gawk libgcrypt20-dev steghide qrencode python python2.7 python3-pip python3-dev libssl-dev make gcc sudo gettext bsdmainutils file pinentry-curses xxd libsodium23 libsodium-dev doas && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir setuptools wheel

COPY . /Tomb/

COPY extras/test/doas.conf /etc/doas.conf
RUN chmod 400 /etc/doas.conf

WORKDIR /Tomb
RUN make --directory=extras/kdf-keys
RUN make --directory=extras/kdf-keys install

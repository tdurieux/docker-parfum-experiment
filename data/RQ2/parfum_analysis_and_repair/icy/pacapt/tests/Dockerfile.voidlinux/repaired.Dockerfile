FROM voidlinux/voidlinux:20201117RC01

RUN SSL_NO_VERIFY_PEER=true xbps-install -S
RUN SSL_NO_VERIFY_PEER=true xbps-install -uy xbps
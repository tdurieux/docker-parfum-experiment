FROM jekyll/builder:3.8

RUN apk add --no-cache util-linux pciutils usbutils coreutils binutils findutils grep


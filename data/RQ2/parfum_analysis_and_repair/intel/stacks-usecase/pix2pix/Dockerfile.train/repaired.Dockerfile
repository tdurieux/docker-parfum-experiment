FROM clearlinux/stacks-dlrs-oss:latest

COPY ./. /pix2pix


RUN swupd bundle-add devpkg-libjpeg-turbo \
    && CFLAGS="${CFLAGS} -mavx2" pip install --no-cache-dir --compile pillow-simd \
    && cd /pix2pix && pip install --no-cache-dir -r requirements.txt

CMD bash
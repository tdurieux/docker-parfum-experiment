FROM ubuntu:20.04 AS Builder
LABEL maintainer="s.k.noe@hinoshiba.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --no-install-recommends -y tzdata locales \
        xserver-xorg x11-apps fonts-migmix \
        tesseract-ocr tesseract-ocr-jpn tor tsocks && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y curl firefox chromium-browser && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ADD ./run.sh /work/run.sh
ADD ./torrc /etc/tor/torrc
ADD ./tsocks.conf /etc/tsocks.conf

RUN chmod 777 /work/run.sh

WORKDIR /work
CMD ["/work/run.sh"]

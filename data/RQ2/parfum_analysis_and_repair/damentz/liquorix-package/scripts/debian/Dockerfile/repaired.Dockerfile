ARG ARCH
ARG DISTRO
ARG RELEASE

FROM $ARCH/$DISTRO:$RELEASE

ARG DEFAULT
ARG PUBLIC
ARG SECRET

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install --no-install-recommends eatmydata -y && \
    apt-get clean && \
    rm -rfv /var/lib/apt/lists/*

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libeatmydata.so
RUN apt-get update &&\
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y \
        build-essential \
        devscripts \
        equivs \
        wget \
        gnupg \
        schedtool && \
    apt-get clean && \
    rm -rfv /var/lib/apt/lists/*

RUN echo "$PUBLIC" | gpg --batch --import && \
    echo "$SECRET" | gpg --batch --import && \
    echo "default-key $DEFAULT" > ~/.gnupg/gpg.conf

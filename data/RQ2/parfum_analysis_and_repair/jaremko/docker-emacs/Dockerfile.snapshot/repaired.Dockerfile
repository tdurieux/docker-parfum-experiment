ARG VERSION=latest
FROM ubuntu:$VERSION

MAINTAINER JAremko <w3techplaygound@gmail.com>

# Fix "Couldn't register with accessibility bus" error message
ENV NO_AT_BRIDGE=1

ENV DEBIAN_FRONTEND noninteractive

# basic stuff
RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    dbus-x11 \
    fontconfig \
    git \
    gzip \
    language-pack-en-base \
    libgl1-mesa-glx \
    make \
    sudo \
    tar \
    unzip \
# su-exec
    && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && chmod 770 su-exec \
    && mv ./su-exec /usr/local/sbin/ \
# Cleanup
    && apt-get purge build-essential \
    && apt-get autoremove \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

COPY asEnvUser /usr/local/sbin/

# Only for sudoers
RUN chown root /usr/local/sbin/asEnvUser \
    && chmod 700  /usr/local/sbin/asEnvUser

# ^^^^^^^ Those layers are shared ^^^^^^^

# Emacs
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common \
    && apt-add-repository ppa:ubuntu-elisp/ppa \
    && apt-get update && apt-get install -y --no-install-recommends emacs-snapshot \
# Cleanup
    && apt-get purge software-properties-common \
    && rm -rf /tmp/* /var/lib/apt/lists/* /root/.cache/*

ENV UNAME="emacser" \
    GNAME="emacs" \
    UHOME="/home/emacs" \
    UID="1000" \
    GID="1000" \
    WORKSPACE="/mnt/workspace" \
    SHELL="/bin/bash"

WORKDIR "${WORKSPACE}"

ENTRYPOINT ["asEnvUser"]
CMD ["bash", "-c", "emacs; /bin/bash"]

FROM ubuntu:16.04
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y \
    && apt install --no-install-recommends -y g++-multilib git ca-certificates && rm -rf /var/lib/apt/lists/*;

# Node
RUN apt install --no-install-recommends -y curl wget \
    && curl -f -sL https://deb.nodesource.com/setup_9.x | bash - && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN node -v

# sampctl
COPY ./docker/sampctl-install.sh /tmp
RUN chmod +x /tmp/sampctl-install.sh \
    && /tmp/sampctl-install.sh
RUN sampctl --appVersion

WORKDIR /samp
ENTRYPOINT ["sampctl package run"]
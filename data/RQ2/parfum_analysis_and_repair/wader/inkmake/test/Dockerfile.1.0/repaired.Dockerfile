FROM debian:bullseye
RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    inkscape \
    ruby \
    fonts-noto \
    locales && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["inkmake"]

FROM debian

# from https://sourceforge.net/projects/bootinfoscript
ADD bootinfoscript /usr/local/bin/

# bsdmainutils: hexdump
RUN apt-get update \
    && apt-get install --no-install-recommends -yq bsdmainutils gawk xz-utils lzma file && rm -rf /var/lib/apt/lists/*;

CMD ["bootinfoscript", "--stdout"]

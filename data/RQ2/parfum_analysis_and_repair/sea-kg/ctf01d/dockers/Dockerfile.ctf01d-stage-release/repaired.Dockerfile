FROM debian:10
# stage release
LABEL "maintainer"="Evgenii Sopov <mrseakg@gmail.com>"
LABEL "repository"="https://github.com/sea-kg/ctf01d"

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y \
    libcurl4 \
    zlibc \
    zlib1g \
    libpng16-16 \
    libmariadb3 \
    libpthread-stubs0-dev \
    libssl-dev \
    python \
    python-pip \
    python3 \
    python3-pip \
    && pip install --no-cache-dir requests \
    && pip3 install --no-cache-dir requests && rm -rf /var/lib/apt/lists/*;

# COPY --from=0 /root/your-project/your-project.bin /usr/bin/your-project.bin

# EXPOSE 8080
# CMD ["your-project.bin","start"]
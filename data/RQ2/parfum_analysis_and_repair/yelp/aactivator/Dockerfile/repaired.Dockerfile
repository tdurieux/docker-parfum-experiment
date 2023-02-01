FROM ubuntu:jammy

RUN apt-get update  \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        devscripts \
        dumb-init \
        equivs \
        lintian \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /mnt
CMD [ \
    "dumb-init", \
    "sh", "-euxc", \
    "mk-build-deps -ir --tool 'apt-get --no-install-recommends -y' debian/control && make builddeb" \
]

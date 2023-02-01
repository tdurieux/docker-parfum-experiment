FROM ubuntu:20.04 AS base
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y tzdata gnupg gnupg-utils lsb-release wget ca-certificates apt-transport-https curl screen bc && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT [ "/bin/bash" ]

# Auxiliary RGIS build container
FROM base AS rgisbuild
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends git cmake clang make libnetcdf-dev libudunits2-dev libgdal-dev libexpat1-dev libxext-dev libmotif-dev && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/bmfekete/RGIS /tmp/RGIS && /tmp/RGIS/install.sh /usr/local/share && rm -rf /tmp/RGIS

# RGIS container
FROM base AS rgis
RUN apt-get install -y --no-install-recommends libudunits2-0 libudunits2-data libexpat1 libmotif-common && rm -rf /var/lib/apt/lists/*
    COPY --from=rgisbuild /usr/local/share/ghaas /usr/local/share/ghaas
    ENV PATH=\"${PATH}:/usr/local/share/ghaas/bin:/usr/local/share/ghaas/f\"
    VOLUME [ "/data" ]
    VOLUME [ "/scratch" ]
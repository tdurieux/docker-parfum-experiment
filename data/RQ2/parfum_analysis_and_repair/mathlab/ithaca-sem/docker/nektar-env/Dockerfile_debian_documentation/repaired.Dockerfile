FROM %%BASE_IMAGE%%:env-buster-default

USER root
COPY docker/nektar-env/buster_documentation_packages.txt packages.txt

RUN echo "deb http://deb.debian.org/debian buster non-free" > \
        /etc/apt/sources.list.d/debian-non-free.list && \
        apt-get update && \
        apt-get install --no-install-recommends -y $(cat packages.txt) \
        && rm -rf /var/lib/apt/lists/*

# Patch security policy to allow PDF conversion by ImageMagick
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/g' /etc/ImageMagick-6/policy.xml

USER nektar:nektar

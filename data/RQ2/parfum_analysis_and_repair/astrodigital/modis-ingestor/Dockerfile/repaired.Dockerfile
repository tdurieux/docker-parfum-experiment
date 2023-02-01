FROM astrodigital/modispds:base

WORKDIR /build

COPY ./ /build/

RUN \
    pip install --no-cache-dir .

ENTRYPOINT ["modis-pds"]
CMD []

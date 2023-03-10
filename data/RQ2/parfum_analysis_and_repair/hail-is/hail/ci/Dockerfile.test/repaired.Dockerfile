FROM {{ base_image.image }}

COPY hail/python/setup-hailtop.py /hailtop/setup.py
COPY hail/python/hailtop /hailtop/hailtop/
COPY /hail_version /hailtop/hailtop/hail_version
COPY hail/python/MANIFEST.in /hailtop/MANIFEST.in
RUN hail-pip-install /hailtop && rm -rf /hailtop
COPY ci/test/ /test/
FROM {{ base_image.image }}

COPY hail/python/setup-hailtop.py /hailtop/setup.py
COPY hail/python/hailtop /hailtop/hailtop/
RUN python3 -m pip install --no-cache-dir /hailtop \
  && rm -rf /hailtop

COPY pipeline/test /test/

CMD ["python3", "-m", "pytest", "-v", "-s", "/test/"]

ARG FROM
FROM ${FROM}

WORKDIR /usr/src/app

# Must build from source to be able to run tests
# https://github.com/geopandas/geopandas
RUN git clone \
    --branch v0.8.1 \
    --depth 1 \
    https://github.com/geopandas/geopandas \
    .

RUN apt-get update && apt-get install --no-install-recommends -y libgeos-dev && rm -rf /var/lib/apt/lists/*;

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir \
    cython \
    fiona \
    pyproj \
    pytest \
    pytest-cov \
    pytest-xdist \
    fsspec \
    SQLalchemy \
    pyarrow \
    geopy \
    mapclassify >=2.2.0 \
    pandas \
    matplotlib \
    shapely \
    pytest-custom_exit_code

RUN python -c "import geopandas"

ENV PYTHON_RECORD_API_FROM_MODULES=geopandas
CMD [ "pytest", "geopandas", "--verbose", "--suppress-tests-failed-exit-code"]

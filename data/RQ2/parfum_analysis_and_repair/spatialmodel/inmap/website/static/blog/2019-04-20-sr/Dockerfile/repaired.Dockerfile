FROM jupyter/base-notebook:latest

USER root

RUN apt-get update && \
	apt-get install --no-install-recommends -y binutils libproj-dev gdal-bin libspatialindex-dev && rm -rf /var/lib/apt/lists/*;

USER jovyan

RUN pip install --no-cache-dir geopandas scipy matplotlib numpy pandas shapely fiona \
  six pyproj geopy psycopg2-binary rtree descartes pysal xlrd

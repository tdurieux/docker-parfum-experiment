FROM python:3.8.3
WORKDIR /tmp

# Install the compilation tools
RUN apt-get update -y && \
  apt-get install --no-install-recommends -y build-essential software-properties-common zip unzip ca-certificates git -y && \
  pip install --no-cache-dir --upgrade pip && \
  apt-get update && rm -rf /var/lib/apt/lists/*;

# Install libspatialindex
RUN wget https://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz && \
  tar -xvzf spatialindex-src-1.8.5.tar.gz && \
  cd spatialindex-src-1.8.5 && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make && \
  make install && \
  cd - && \
  rm -rf spatialindex-src-1.8.5* && \
  ldconfig && \
  pip install --no-cache-dir pygeoda && \
  apt-get install -y --no-install-recommends r-base && \
  apt-get install --no-install-recommends -y libudunits2-dev gfortran libgdal-dev && \
  Rscript -e "install.packages(c('dplyr', 'classInt', 'sf'))" && rm spatialindex-src-1.8.5.tar.gz && rm -rf /var/lib/apt/lists/*;


# Install geopandas
RUN pip install --no-cache-dir rtree geopandas pandas boto3 requests grequests pytz us lxml
RUN pip install --no-cache-dir bs4 protobuf pandas_gbq google-cloud-bigquery regex

# Move entrypoint script to container and deploy key and gbq key to ssh folder
COPY entrypoint.sh .
COPY id_rsa /root/.ssh/id_rsa
COPY gbq-credentials.json /root/.ssh/gbq-credentials.json

# Run git clone, get data, git push
ENTRYPOINT ["sh", "entrypoint.sh"]
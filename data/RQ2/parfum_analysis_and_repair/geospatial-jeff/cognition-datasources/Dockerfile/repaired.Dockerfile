FROM lambci/lambda:build-python3.6


# Installing system libraries
RUN \
    yum install -y wget; rm -rf /var/cache/yum \
    yum install -y geos-devel; \
    yum clean all; \
    yum autoremove;


# Paths
ENV \
    PREFIX=/usr/local \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64

# Switch to build directory
WORKDIR /build

# Installing cognition-datasources + requirements
COPY requirements-dev.txt ./

RUN \
    pip install --no-cache-dir -r requirements-dev.txt; \
    pip install --no-cache-dir git+https://github.com/geospatial-jeff/cognition-datasources.git



# Copy shell scripts
COPY bin/* /usr/local/bin/

WORKDIR /home/cognition-datasources
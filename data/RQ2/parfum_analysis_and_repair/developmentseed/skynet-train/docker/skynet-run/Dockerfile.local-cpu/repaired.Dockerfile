FROM developmentseed/caffe-segnet:cpu
ENV DEBIAN_FRONTEND noninteractive
RUN sudo apt-get update && sudo apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

# GDAL
RUN sudo apt-get install --no-install-recommends software-properties-common -y && \
    sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable -y && \
    sudo apt-get update && sudo apt-get install --no-install-recommends gdal-bin python-gdal libgdal1-dev -y && rm -rf /var/lib/apt/lists/*;

# Node
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    sudo apt-get install --no-install-recommends -y nodejs build-essential libagg-dev libpotrace-dev && rm -rf /var/lib/apt/lists/*;

# Python
RUN pip install --no-cache-dir numpy==1.14.2

RUN pip install --no-cache-dir flask && \
    pip install --no-cache-dir mercantile && \
    pip install --no-cache-dir rasterio==1.0a12 && \
    pip install --no-cache-dir boto3 && \
    pip install --no-cache-dir pyproj && \
    pip install --no-cache-dir git+https://github.com/flupke/pypotrace.git@master

ADD package.json /workspace/package.json
RUN npm install && npm cache clean --force;
ADD . /workspace
EXPOSE 5000

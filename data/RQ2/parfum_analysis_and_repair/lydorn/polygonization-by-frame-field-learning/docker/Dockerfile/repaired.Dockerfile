#FROM pytorch/pytorch:1.2-cuda10.0-cudnn7-devel
FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

MAINTAINER Nicolas Girard <nicolas.jp.girard@gmail.com>

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y locales && \
    locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    libgtk2.0 \
    fish && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pyproj

# Install gdal
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update
RUN apt-get install --no-install-recommends -y libgdal-dev && rm -rf /var/lib/apt/lists/*;
# See https://gist.github.com/cspanring/5680334:
RUN pip install --no-cache-dir gdal==$(gdal-config --version) --global-option=build_ext --global-option="-I/usr/include/gdal/"

# Install overpy
RUN pip install --no-cache-dir overpy

# Install shapely
RUN pip install --no-cache-dir Shapely

RUN pip install --no-cache-dir jsmin

# Install tqdm for terminal progress bar
RUN pip install --no-cache-dir tqdm

# Install Jupyter notebook
RUN pip install --no-cache-dir jupyter

# Install sklearn
RUN pip install --no-cache-dir scikit-learn

# Install multiprocess in replacement to the standard multiprocessing which does not allow methods to be serialized
RUN pip install --no-cache-dir multiprocess

# Instal Kornia: Open Source Differentiable Computer Vision Library for PyTorch
RUN pip install --no-cache-dir git+https://github.com/Lydorn/kornia@7bcb52125917eedee867ec93ed56c289019bd7d2

# Install rasterio
RUN pip install --no-cache-dir rasterio

# Install skimage
RUN pip install --no-cache-dir scikit-image

# Install Tensorboard
#RUN conda install -c anaconda absl-py
RUN pip install --no-cache-dir tensorboard

# Install geojson
RUN pip install --no-cache-dir geojson

# Install fiona
RUN pip install --no-cache-dir fiona

# Install pycocotools
RUN pip install -U --no-cache-dir cython
RUN pip install --no-cache-dir "git+https://github.com/cocodataset/cocoapi.git#egg=pycocotools&subdirectory=PythonAPI"

# Install pip install tifffile
RUN pip install --no-cache-dir tifffile

# Downgrade Pillow so that it works with PyTorch 1.1
RUN pip install --no-cache-dir "Pillow<7.0.0"

# Install future for tensorboard
RUN pip install --no-cache-dir future

# Descartes for plotting shapely polygons
RUN pip install --no-cache-dir descartes

# OpenCV:
RUN apt-get install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN conda install -c conda-forge opencv=4.2.0

# Skan
RUN conda install -c conda-forge skan

# torch-scatter
RUN pip install --no-cache-dir torch-scatter==latest+cu101 -f https://pytorch-geometric.com/whl/torch-1.4.0.html

# Cleanup
RUN apt-get clean && \
    apt-get autoremove

COPY start_jupyter.sh /

WORKDIR /app

CMD fish
FROM continuumio/anaconda
RUN apt-get install --no-install-recommends -y gcc g++ tar git curl nano wget dialog net-tools build-essential pyqt4-dev-tools && rm -rf /var/lib/apt/lists/*;
RUN conda install rasterio numpy cython shapely jupyter
RUN pip install --no-cache-dir gdal
RUN pip install --no-cache-dir pygeoprocessing pygeotools
RUN mkdir /data /notebooks
COPY /data/ /data
# annoyingly, the conda install doesn't set this environment variable.
ENV GDAL_DATA /opt/conda/share/gdal
RUN pip install --no-cache-dir greenwich

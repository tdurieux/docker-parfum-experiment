FROM continuumio/miniconda3:master

RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate && \
    conda create --name CloudComPy39 python=3.9 && \
    conda activate CloudComPy39 && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict && \
    conda install boost cgal cmake eigen ffmpeg gdal jupyterlab matplotlib mysql numpy opencv openmp pcl pdal psutil "qhull=2019.1" qt scipy sphinx_rtd_theme spyder tbb tbb-devel xerces-c

RUN apt-get update && apt-get install --no-install-recommends -y clang make libgl1 && rm -rf /var/lib/apt/lists/*;

RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate CloudComPy39 && \
    cd && git clone --recurse-submodules https://github.com/prascle/CloudComPy.git

COPY genCloudComPy_Conda39_docker.sh /root/

RUN cd /root && ./genCloudComPy_Conda39_docker.sh

RUN echo "#!/bin/bash\n\
. /opt/conda/etc/profile.d/conda.sh\n\
cd /opt/installConda/CloudComPy39\n\
. bin/condaCloud.sh activate CloudComPy39\n\
export QT_QPA_PLATFORM=offscreen\n\
cd /opt/installConda/CloudComPy39/doc/PythonAPI_test\n\
ctest" > /execTests.sh && chmod +x /execTests.sh

FROM nvcr.io/nvidia/pytorch:20.09-py3
#nvcr.io/nvidia/cuda:10.2-runtime
#

EXPOSE 8888
EXPOSE 6006
EXPOSE 8003

#ADD . .

ENV http_proxy=http://proxy1.bgc-jena.mpg.de:3128 \
    ftp=http://proxy1.bgc-jena.mpg.de:3128 \
    https_proxy=http://proxy1.bgc-jena.mpg.de:3128

#RUN conda install anaconda-clean
#RUN anaconda-clean --yes

RUN apt-get -y update \
    && apt-get install --no-install-recommends -y software-properties-common \
    && apt-get -y update \
    && add-apt-repository universe \
    && add-apt-repository ppa:ubuntugis/ppa && rm -rf /var/lib/apt/lists/*;

#RUN apt -y install python3.7-dev
#RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
#RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 2
#RUN python3.7 --version

#RUN apt-get -y install python3-pip
RUN apt-get -y --no-install-recommends install libglib2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install pv && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libavcodec-dev libavformat-dev libswscale-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgtk-3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libjpeg-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libopenexr-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libtiff-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libwebp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install screen && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ffmpeg --fix-missing && rm -rf /var/lib/apt/lists/*;

RUN conda init bash
RUN conda update -y python
RUN conda install -y python=3.7.7
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade setuptools
RUN pip3 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir matplotlib tqdm Pillow shapely opencv-python pandas scikit-learn imgaug imantics scipy scikit-image seaborn pandas
RUN pip3 install --no-cache-dir netCDF4
RUN pip3 install --no-cache-dir earthnet


#Install GDAL and python binding
RUN apt-get install --no-install-recommends -y gdal-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgdal-dev && rm -rf /var/lib/apt/lists/*;
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal
RUN ogrinfo --version

#Add here the ogr version
RUN pip3 install --no-cache-dir GDAL==2.4.2
RUN pip3 install --no-cache-dir git+https://gitext.gfz-potsdam.de/danschef/geoarray.git
RUN pip3 install --no-cache-dir git+https://gitext.gfz-potsdam.de/danschef/arosics.git
RUN pip3 install --no-cache-dir sentinelsat sentinelhub Cartopy

#JupyterLab Set-up
RUN conda install qt
RUN conda install -y jupyter jupyterlab
RUN pip3 install --no-cache-dir jupytext
RUN pip3 install --no-cache-dir jupyter_tensorboard
RUN pip3 install --no-cache-dir --upgrade jupyterlab-git
RUN conda install -y nb_conda_kernels
#RUN jupyter lab build

#Create the conda environment for Tf_template named ENtf115py36
RUN conda create --name ENtf115py36 python=3.6
RUN source activate ENtf115py36 && pip3 install --no-cache-dir numpy matplotlib scipy sk-video ffmpeg opencv-python scikit-image h5py tensorflow-gpu==1.15 earthnet && conda install -y ipykernel


#Create the conda environment for PyTorch_template named ENpt16py38
RUN conda create --name ENpt16py38 python=3.8.5
SHELL ["conda", "run", "-n", "ENpt16py38", "/bin/bash", "-c"]
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir numpy==1.19.2
RUN pip3 install --no-cache-dir torch==1.6.0 torchvision==0.7.0 pytorch-lightning==1.1.0
RUN pip3 install --no-cache-dir matplotlib==3.3.2 tqdm Pillow shapely opencv-python pandas scikit-learn imgaug imantics scipy scikit-image seaborn pandas
RUN pip3 install --no-cache-dir earthnet
RUN pip3 install --no-cache-dir segmentation-models-pytorch
RUN conda install -y ipykernel
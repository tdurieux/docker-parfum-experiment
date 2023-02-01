# nVidia TensorRT Base Image
ARG TRT_CONTAINER_VERSION=21.12
FROM nvcr.io/nvidia/pytorch:${TRT_CONTAINER_VERSION}-py3

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /var/www
WORKDIR /var/www

RUN apt-get update

# For opencv
RUN apt-get install --no-install-recommends -y libglib2.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt update
RUN apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;

# turbojpeg
RUN apt-get install --no-install-recommends -y libturbojpeg && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pillow==8.0.1
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir "PyYAML>=5.3"
RUN pip install --no-cache-dir "numpy>=1.16.*"
RUN pip install --no-cache-dir scikit_image
RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir pycocotools
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir seaborn
RUN pip install --no-cache-dir gevent

RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
RUN wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/master.zip
RUN unzip opencv.zip; unzip opencv_contrib.zip
RUN mkdir -p build && cd build;\
    cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-master/modules ../opencv-master; make -j8;\
    make install

RUN rm /var/www/opencv.zip;\
    rm /var/www/opencv_contrib.zip;\
    rm -rf /var/www/opencv-master;\
    rm -rf /var/www/opencv_contrib-master;\
    rm -rf /var/www/build

RUN pip install --no-cache-dir "numpy>=1.16.*"
RUN pip install --no-cache-dir imgaug
RUN pip install --no-cache-dir "pillow>=8.2.0"
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir asyncio
RUN pip install --no-cache-dir GitPython
RUN pip install --no-cache-dir gevent
RUN pip install --no-cache-dir pycocotools
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir termcolor
RUN pip install --no-cache-dir ujson
RUN pip install --no-cache-dir pytorch_lightning
RUN pip install --no-cache-dir ipywidgets
RUN pip install --no-cache-dir -U "git+https://github.com/lilohuang/PyTurboJPEG.git"
RUN pip install --no-cache-dir -U "git+https://github.com/ria-com/modelhub-client.git"

RUN pip install --no-cache-dir jupyter
RUN apt-get install --no-install-recommends -y mc && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir nvidia-pyindex
RUN python -m pip install --upgrade nvidia-tensorrt
RUN pip install --no-cache-dir pycuda

WORKDIR /var/www/nomeroff-net

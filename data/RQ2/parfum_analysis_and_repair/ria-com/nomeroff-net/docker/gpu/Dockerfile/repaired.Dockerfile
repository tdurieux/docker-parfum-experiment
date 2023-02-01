FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /var/www
WORKDIR /var/www

RUN apt-get update

# For opencv
RUN apt-get install --no-install-recommends -y libglib2.0 && rm -rf /var/lib/apt/lists/*;

# For pip modules
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

# turbojpeg
RUN apt-get install --no-install-recommends -y libturbojpeg && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir "PyYAML>=5.3"
RUN pip3 install --no-cache-dir scikit_image
RUN pip3 install --no-cache-dir Cython
RUN pip3 install --no-cache-dir pycocotools
RUN pip3 install --no-cache-dir matplotlib
RUN pip3 install --no-cache-dir seaborn
RUN pip3 install --no-cache-dir 'opencv_python<4.5.5'
RUN pip3 install --no-cache-dir "numpy>=1.16.*"
RUN pip3 install --no-cache-dir imgaug
RUN pip3 install --no-cache-dir pillow
RUN pip3 install --no-cache-dir scipy
RUN pip3 install --no-cache-dir termcolor
RUN pip3 install --no-cache-dir ujson
RUN pip3 install --no-cache-dir gevent
RUN pip3 install --no-cache-dir asyncio
RUN pip3 install --no-cache-dir GitPython
RUN pip3 install --no-cache-dir pycocotools
RUN pip3 install --no-cache-dir tqdm
RUN pip3 install --no-cache-dir pytorch_lightning
RUN pip3 install --no-cache-dir -U "git+https://github.com/lilohuang/PyTurboJPEG.git"
RUN pip3 install --no-cache-dir -U "git+https://github.com/ria-com/modelhub-client.git"

WORKDIR /var/www/nomeroff-net

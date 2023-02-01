FROM ubuntu:16.04

RUN echo 'building CPU sia-cog image'

MAINTAINER Deepak Battini "deepak.battini@siadroid.com"
LABEL description="sia-cog cognitive and machine learning API / CPU version"

RUN ln -sf /dev/stdout /var/log/siacog.log
RUN ln -sf /dev/stderr /var/log/siacog.log

RUN useradd -ms /bin/bash sia

RUN echo 'building CPU sia-cog image'
RUN apt-get update && apt-get install --no-install-recommends -y python-setuptools python-pip python-dev git cmake build-essential wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libopencv-dev libssl-dev libffi-dev libfann-dev swig tesseract-ocr python-tk openmpi-bin && rm -rf /var/lib/apt/lists/*;

CMD python -m pip install --upgrade pip
RUN pip install --no-cache-dir setuptools Flask Cython Keras tensorflow mxnet sklearn pandas matplotlib h5py pillow requests simplejson opencv-python jsonpickle pytesseract nltk chatterbot urllib3 easydict padatious seaborn mpld3 psutil nvidia-ml-py flask_cors passlib flask-sqlalchemy

RUN pip install --no-cache-dir -e git+https://github.com/mycroftai/adapt#egg=adapt-parser
RUN apt-get -y --no-install-recommends install openmpi-bin && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir https://cntk.ai/PythonWheel/CPU-Only/cntk-2.1-cp27-cp27mu-linux_x86_64.whl
ENV KERAS_BACKEND=cntk

RUN apt-get clean
RUN apt-get autoremove -y
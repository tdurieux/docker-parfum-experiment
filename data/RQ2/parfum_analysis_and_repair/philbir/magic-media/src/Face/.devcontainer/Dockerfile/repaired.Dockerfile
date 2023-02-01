FROM hellozcb/face_recognition

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir pymongo && \
    pip install --no-cache-dir imutils && \
    pip install --no-cache-dir opencv-python && \
    pip install --no-cache-dir --upgrade ptvsd && \
    pip install --no-cache-dir sklearn && \
    pip install --no-cache-dir Flask && \
    pip install --no-cache-dir isodate && \
    pip3 install --no-cache-dir tensorflow==1.15 && \
    pip3 install --no-cache-dir python-graphql-client && \
    #pip3 install --ignore-installed --upgrade https://github.com/lakshayg/tensorflow-build/releases/download/tf1.10.0-ubuntu18.04-py36-py27/tensorflow-1.10.0-cp36-cp36m-linux_x86_64.whl --user && \
    pip3 install --no-cache-dir pillow && \
    pip3 install --no-cache-dir matplotlib && \
    pip3 install --no-cache-dir h5py && \
    pip3 install --no-cache-dir keras==2.2.4 && \
    pip3 install --no-cache-dir https://github.com/OlafenwaMoses/ImageAI/releases/download/2.1.0/imageai-2.1.0-py3-none-any.whl

EXPOSE 7102
EXPOSE 5001
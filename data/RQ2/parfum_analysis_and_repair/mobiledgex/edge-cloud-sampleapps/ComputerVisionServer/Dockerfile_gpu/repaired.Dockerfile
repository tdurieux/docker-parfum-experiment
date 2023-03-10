FROM nvidia/cuda:10.0-cudnn7-devel AS compile-image

#get deps
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
python3.7-dev python3-pip git g++ wget make libprotobuf-dev protobuf-compiler libopencv-dev \
libgoogle-glog-dev libboost-all-dev libcaffe-cuda-dev libhdf5-dev libatlas-base-dev && rm -rf /var/lib/apt/lists/*;

#replace cmake as old version has CUDA variable bugs
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.tar.gz && \
tar xzf cmake-3.16.0-Linux-x86_64.tar.gz -C /opt && \
rm cmake-3.16.0-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.16.0-Linux-x86_64/bin:${PATH}"

#get openpose
WORKDIR /openpose
RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git .

#build it
WORKDIR /openpose/build
#patch because dataset server posefs1.perception.cs.cmu.edu horribly slow (2020-09-04)
RUN sed -i 's/posefs1.perception.cs.cmu.edu/opencv.facetraining.mobiledgex.net/g' /openpose/CMakeLists.txt
# patch to comment this line out because our version of Cuda doesn't support AMPERE architecture
# TODO: 2020-12-01: When 11.0-cudnn8-devel-ubuntu20.04 is available, we will revisit this.
# Check for updates here: https://gitlab.com/nvidia/container-images/cuda/blob/master/doc/supported-tags.md
RUN sed -i 's/set(AMPERE "80 86")/#set(AMPERE "80 86")/g' /openpose/cmake/Cuda.cmake
RUN cmake -DBUILD_PYTHON=ON ..
RUN sed -i 's/set(AMPERE "80 86")/#set(AMPERE "80 86")/g' /openpose/3rdparty/caffe/cmake/Cuda.cmake
RUN make -j `nproc`

# Use a virtualenv for all of our Python requirements.
RUN apt-get install --no-install-recommends -y python3.7-venv && rm -rf /var/lib/apt/lists/*;
RUN python3.7 -m venv /opt/venv
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir wheel
# Special handling for imagecodecs package. See https://pypi.org/project/imagecodecs/
RUN python -m pip install --upgrade pip setuptools
RUN python -m pip install --upgrade imagecodecs

# Dependencies for our Django app.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM nvidia/cuda:10.0-cudnn7-runtime AS build-image
COPY --from=compile-image /openpose /openpose
COPY --from=compile-image /opt/venv /opt/venv
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
python3.7-dev python3-pip git g++ wget make libopencv-dev iputils-ping \
libgoogle-glog-dev libboost-all-dev libcaffe-cuda-dev libhdf5-dev libatlas-base-dev && rm -rf /var/lib/apt/lists/*;

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# Download weights file required for object detection
WORKDIR /usr/src/app/moedx/pytorch_objectdetecttrack/config
RUN wget https://opencv.facetraining.mobiledgex.net/files/yolov3.weights
WORKDIR /usr/src/app/moedx
COPY . /usr/src/app
# Initialize the database.
RUN python manage.py makemigrations tracker
RUN python manage.py migrate

RUN python manage.py collectstatic --noinput

# port for REST
EXPOSE 8008/tcp

# Fix for "click" Python library, a uvicorn dependency.
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

CMD ["gunicorn","moedx.asgi:application","--bind", "0.0.0.0:8008","-k","uvicorn.workers.UvicornWorker","--workers","1"]

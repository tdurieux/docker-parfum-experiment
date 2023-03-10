FROM nvidia/cuda:9.0-runtime-ubuntu16.04
WORKDIR /app
EXPOSE 3333
RUN apt update && \
    apt install --no-install-recommends -y libsm6 libxrender1 libfontconfig1 python3-pip python3-setuptools vim ffmpeg wget curl && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

RUN pip install --no-cache-dir --upgrade pip
ADD requirements.txt requirements_x86_64.txt ./
# This will have errors, apparently because python 3.5 is out of support. At some point we need to recompile darknet against higher version of cuda.
RUN pip install --no-cache-dir -r requirements_x86_64.txt

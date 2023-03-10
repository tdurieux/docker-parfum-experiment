FROM jetsistant/cuda-jetpack:4.2.1-runtime
WORKDIR /app
EXPOSE 3333
RUN rm -rf /etc/apt/sources.list.d/cuda.list && \
	apt update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install --no-install-recommends -y python3-opencv libsm6 libxrender1 libfontconfig1 python3-pip python3-setuptools vim wget curl \
        libgstreamer-plugins-base1.0-0 libgstreamer1.0-0 libgtk2.0-0 && \
	rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10 && \
	update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

## Additional OpenCV dependencies usually installed by the CUDA Toolkit
ADD scripts/libopencv_3.3.1-2-g31ccdfe11_arm64.deb /tmp
RUN dpkg --install /tmp/libopencv_3.3.1-2-g31ccdfe11_arm64.deb
RUN rm -rf /tmp/libopencv_3.3.1-2-g31ccdfe11_arm64.deb

ADD requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

FROM colmap/colmap:latest
MAINTAINER Paul-Edouard Sarlin
ARG PYTHON_VERSION=3.8
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y unzip wget software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y python${PYTHON_VERSION} && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py && python${PYTHON_VERSION} get-pip.py
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
COPY . /app
WORKDIR app/
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir notebook

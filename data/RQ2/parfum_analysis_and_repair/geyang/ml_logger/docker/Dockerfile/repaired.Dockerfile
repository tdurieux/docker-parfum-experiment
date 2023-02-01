FROM conda/miniconda3
ENV LANG=C.UTF-8
ENV PIP_NO_CACHE_DIR=off

RUN apt-get update
RUN apt-get install --no-install-recommends -y git vim tree curl unzip xvfb patchelf ffmpeg cmake swig && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*; # Needed for pyCurl
RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir pytest pytest-forked lz4 pyyaml qt5-py
RUN pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu
RUN pip install --no-cache-dir kornia opencv-python pandas

RUN conda install pycurl
RUN pip install --no-cache-dir jaynes==0.8.11 ml_logger==v0.8.69 waterbear params-proto==2.9.6 functional-notations
RUN pip install --no-cache-dir ml-dash
RUN pip install --no-cache-dir google-cloud-storage

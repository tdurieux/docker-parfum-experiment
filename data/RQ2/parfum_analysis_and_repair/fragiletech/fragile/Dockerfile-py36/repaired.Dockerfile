FROM ubuntu:18.04
ARG JUPYTER_PASSWORD=fragile
ENV BROWSER=/browser \
    LC_ALL=en_US.UTF-8
COPY requirements.txt fragile/requirements.txt
COPY requirements-viz.txt fragile/requirements-viz.txt
RUN apt-get update && \
    apt-get install -y --no-install-suggests --no-install-recommends \
      ca-certificates locales pkg-config apt-utils gcc g++ wget make git cmake libffi-dev \
      libjpeg-turbo-progs libglib2.0-0 python3.6 python3.6-dev python3-distutils python3-setuptools \
      libjpeg8-dev zlib1g zlib1g-dev libsm6 libxext6 libxrender1 libfontconfig1 pkg-config flex \
      bison curl libpng16-16 libpng-dev libjpeg-turbo8 libjpeg-turbo8-dev zlib1g-dev libhdf5-100 \
      libhdf5-dev libopenblas-base libopenblas-dev gfortran libfreetype6 libfreetype6-dev && \
    ln -s /usr/lib/x86_64-linux-gnu/libz.so /lib/ && \
    ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /lib/ && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    wget -O - https://bootstrap.pypa.io/get-pip.py | python3 && \
    rm -rf /var/lib/apt/lists/* && \
    echo '#!/bin/bash\n\
\n\
echo\n\
echo "  $@"\n\
echo\n\' > /browser && \
    chmod +x /browser


# install FractalAI deps
ENV NPY_NUM_BUILD_JOBS 8
RUN pip3 install --no-cache-dir cython && \
    pip3 install --no-cache-dir \
         h5py Pillow-simd PyOpenGL && \
    pip3 install --no-cache-dir -U https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-0.9.0.dev0-cp36-cp36m-manylinux1_x86_64.whl && \
    pip3 install --no-cache-dir git+https://github.com/FragileTech/atari-py#egg=atari-py && \
    cd fragile && \
    pip3 install --no-cache-dir -r requirements.txt --no-use-pep517 && \
    pip3 install --no-cache-dir -r requirements-viz.txt --no-use-pep517 && \
    python3 -c "import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot"

# Install holoviews image save
RUN pip3 install --no-cache-dir selenium && apt install --no-install-recommends curl -y && \
    curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install phantomjs --unsafe-perm && \
    npm install -g phantomjs-prebuilt --unsafe-perm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

COPY . fragile/

RUN cd fragile && pip3 install --no-cache-dir -e .["all"] --no-use-pep517 && pip3 install --no-cache-dir jupyter psutil setproctitle

RUN pip3 uninstall -y cython && \
    apt-get remove -y cmake pkg-config flex bison curl libpng-dev \
        libjpeg-turbo8-dev zlib1g-dev libhdf5-dev libopenblas-dev gfortran \
        libfreetype6-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /root/.jupyter && \
    echo 'c.NotebookApp.token = "'${JUPYTER_PASSWORD}'"' > /root/.jupyter/jupyter_notebook_config.py
CMD jupyter notebook --allow-root --port 8080 --ip 0.0.0.0
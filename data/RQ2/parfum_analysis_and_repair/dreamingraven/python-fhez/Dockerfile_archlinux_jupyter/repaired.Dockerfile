FROM archlinux:latest

# directory containing source files with respect to dockerfile
ARG SRCDIR="."
# directory where the source will exist in the dockerfile
ARG PKGDIR="/app"

# resetting all gnupg keys
RUN rm -rf /etc/pacman.d/gnupg && \
    pacman-key --init && \
    pacman-key --populate archlinux

# resync all packages and check keyring
RUN pacman -Syyuu \
    archlinux-keyring \
    base-devel \
    --noconfirm

# Install dependencies and retrieve seal-python files
RUN pacman -S \
    base-devel \
    cmake \
    clang \
    eigen \
    git \
    fish \
    python \
    python-pip \
    python-sphinx \
    python-sphinx-argparse \
    python-sphinx_rtd_theme \
    python-configargparse \
    jupyterlab \
    python-ipykernel \
    python-tqdm \
    python-numpy \
    python-pandas \
    --noconfirm

RUN git clone -b 3.4.5-rlatest https://github.com/DreamingRaven/seal-python seal-python

# Build SEAL packages in seal-python
RUN cd /seal-python/SEAL/native/src && \
    cmake . && \
    make && \
    make install && \
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/seal.conf && \
    ldconfig

# Install requirements of seal-python
RUN cd /seal-python && \
    pip3 install --no-cache-dir -r requirements.txt

# Build pybind11
RUN cd /seal-python/pybind11 && \
    mkdir build && \
    cd /seal-python/pybind11/build && \
    cmake .. && \
    make check -j 4 && \
    make install

# Package wrapper
RUN cd /seal-python && \
    python3 setup.py build_ext -i && \
    python3 setup.py install

# Clean-up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p ${PKGDIR}

# early copy of requirements file
COPY ${SRCDIR}/requirements.txt ${PKGDIR}/requirements.txt

# install package specific dependencies
RUN pip3 install --no-cache-dir -r ${PKGDIR}/requirements.txt

# copy our files in
COPY ${SRCDIR} ${PKGDIR}

RUN cd ${PKGDIR} && \
    python3 setup.py install

# install examples specific/ additional requirements
RUN pip3 install --no-cache-dir -r ${PKGDIR}/examples/requirements.txt

# set default jupyter theme to dark
RUN mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/ && \
    echo '{ "theme":"JupyterLab Dark" }' > ~/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings

WORKDIR ${PKGDIR}

ENTRYPOINT /usr/bin/jupyter lab --allow-root --no-browser --ip "*" ./examples

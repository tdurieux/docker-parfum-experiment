# Install KWIVER to /opt/kitware/kwiver
# Use latest Fletch as base image (Ubuntu 18.04)

FROM kitware/fletch:latest-ubuntu18.04-py3-cuda10.0-cudnn7-devel

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                    python3-dev \
                    python3-pip \
                    xvfb \
 && pip3 install --no-cache-dir setuptools \
                 scipy \
                 six && rm -rf /var/lib/apt/lists/*;

#
# Build KWIVER
#

COPY . /kwiver
RUN cd /kwiver \
  && mkdir build \
  && cd build \
  && cmake ../ -DCMAKE_BUILD_TYPE=Release \
    -Dfletch_DIR:PATH=/opt/kitware/fletch/share/cmake \
    -DKWIVER_ENABLE_ARROWS=ON \
    -DKWIVER_ENABLE_C_BINDINGS=ON \
    -DKWIVER_ENABLE_CERES=ON \
    -DKWIVER_ENABLE_CUDA=ON \
    -DKWIVER_ENABLE_EXTRAS=ON \
    -DKWIVER_ENABLE_LOG4CPLUS=ON \
    -DKWIVER_ENABLE_OPENCV=ON \
    -DKWIVER_ENABLE_FFMPEG=ON \
    -DKWIVER_ENABLE_KLV=ON \
    -DKWIVER_ENABLE_MVG=ON \
    -DKWIVER_ENABLE_PROCESSES=ON \
    -DKWIVER_ENABLE_PROJ=ON \
    -DKWIVER_ENABLE_PYTHON=ON \
    -DKWIVER_ENABLE_SERIALIZE_JSON=ON \
    -DKWIVER_ENABLE_SPROKIT=ON \
    -DKWIVER_ENABLE_TESTS=ON \
    -DKWIVER_ENABLE_TOOLS=ON \
    -DKWIVER_ENABLE_VXL=ON \
    -DKWIVER_ENABLE_DOCS=ON \
    -DKWIVER_INSTALL_DOCS=ON \
    -DKWIVER_PYTHON_MAJOR_VERSION=3 \
    -DKWIVER_USE_BUILD_TREE=ON \
  && make -j$(nproc) -k \
  && make install \
  && chmod +x setup_KWIVER.sh
# Optionally install python build requirements if it was generated.
RUN PYTHON_REQS="python/requirements.txt" \
 && cd /kwiver/build \
 && ( ( [ ! -f "$PYTHON_REQS" ] \
        && echo "!!! No build requirements generated, nothing to install." ) \
      || pip3 install --no-cache-dir -r "$PYTHON_REQS")

# Configure entrypoint
RUN bash -c 'echo -e "source /kwiver/build/setup_KWIVER.sh\n\
\n# Set up X virtual framebuffer (Xvfb) to support running VTK headless\n\
Xvfb :1 -screen 0 1024x768x16 -nolisten tcp > xvfb.log &\n\
export DISPLAY=:1.0\n\n\
kwiver \$@" >> entrypoint.sh' \
 && chmod +x entrypoint.sh

ENTRYPOINT [ "bash", "/entrypoint.sh" ]
CMD [ "help" ]

FROM inducer/debian-amd64-minbase
MAINTAINER Andreas Kloeckner <inform@tiker.net>
EXPOSE 9941
RUN useradd runcode

RUN echo 'APT::Default-Release "testing";' >> /etc/apt/apt.conf

RUN apt-get update && apt-get -y --no-install-recommends -o APT::Install-Recommends=0 -o install \
  python3-scipy \
  python3-numpy \
  python3-pip \
  python3-matplotlib \
  python3-pillow \
  graphviz \
  python3-pandas \
  python3-statsmodels \
  python3-sklearn \
  python3-skimage \
  python3-sympy \
  python3-pip \
  python3-dev \
  python3-setuptools \
  gcc && rm -rf /var/lib/apt/lists/*;

# RUN POCL_VER="1.2~rc2-1"; \
#   apt-get -o APT::Install-Recommends=0 -o APT::Install-Suggests=0 -y install \
#   "pocl-opencl-icd=$POCL_VER" \
#   "libpocl2=$POCL_VER" \
#   "libpocl2-common=$POCL_VER" \
#   "ocl-icd-libopencl1" \
#   "python3-pyopencl" \
#   git
#
# RUN python3 -m pip install git+https://github.com/inducer/loopy.git

RUN apt-get clean
RUN fc-cache

RUN mkdir -p /opt/runcode
ADD runcode /opt/runcode/
COPY code_feedback.py /opt/runcode/
COPY code_run_backend.py /opt/runcode/
RUN ls /opt/runcode

RUN sed -i s/TkAgg/Agg/ /etc/matplotlibrc
RUN echo "savefig.dpi : 80" >> /etc/matplotlibrc
RUN echo "savefig.bbox : tight" >> /etc/matplotlibrc

# RUN pip3 install --upgrade tensorflow
#RUN  find /usr/lib/python3/ -name '*cpython-37m*.so' -delete
RUN rm -Rf /root/.cache

# may use ./flatten-container.sh to reduce disk space

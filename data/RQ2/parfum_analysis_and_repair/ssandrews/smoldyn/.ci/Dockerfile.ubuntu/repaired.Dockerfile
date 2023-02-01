FROM ubuntu:latest
MAINTAINER dilawars@subcom.tech
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt install --no-install-recommends -y cmake vim-nox neovim g++ vtk7 libvtk7-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y freeglut3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-dev python3-setuptools python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install pip --upgrade
RUN python3 -m pip install wheel setuptools --upgrade
COPY . /app
WORKDIR /app
RUN ls /app -ltrh
CMD cd /app && mkdir -p __build && cd __build && \
    cmake -DOPTION_PYTHON=ON .. && make -j2 \
    && make install \
    && python3 -c "import smoldyn; print(smoldyn.__version__)"

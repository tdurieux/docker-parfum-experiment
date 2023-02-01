##################### BASE IMAGE ##########################
FROM python:3.6.15


####################### OPENALPR ############################

RUN git clone https://github.com/norkator/openalpr.git

WORKDIR /openalpr

# Install prerequisites
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    build-essential \
    cmake \
    curl \
    git \
    libcurl3-dev \
    libleptonica-dev \
    liblog4cplus-dev \
    libopencv-dev \
    libtesseract-dev \
    wget && rm -rf /var/lib/apt/lists/*;

# Setup the build directory
RUN mkdir /openalpr/src/build
WORKDIR /openalpr/src/build

# Setup the compile environment
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc .. && \
    make -j2 && \
    make install


##################### OPEN INTELLIGENCE ##########################

# COPY . /app
COPY requirements_linux_container.txt /app/requirements_linux_container.txt

WORKDIR /app

# RUN pip install -r requirements_linux.txt --no-dependencies
RUN pip install --no-cache-dir -r requirements_linux_container.txt

RUN apt-get update
RUN apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;

# docker-compose file introduces mount point to mount source files without copying into docker image

CMD ["python", "./App.py"]
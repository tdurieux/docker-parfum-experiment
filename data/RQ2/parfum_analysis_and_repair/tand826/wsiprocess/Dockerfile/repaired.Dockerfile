FROM python:3.7-slim

ENV VIPSVERSION 8.9.2

# build libvips from source
RUN apt update -y && apt install --no-install-recommends -y wget build-essential pkg-config libglib2.0-dev libexpat1-dev libtiff5-dev libjpeg62-turbo-dev libgsf-1-dev openslide-tools libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/libvips/libvips/releases/download/v${VIPSVERSION}/vips-${VIPSVERSION}.tar.gz && tar xvfz vips-${VIPSVERSION}.tar.gz && rm vips-${VIPSVERSION}.tar.gz
RUN cd vips-${VIPSVERSION} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && ldconfig

# library for opencv
RUN apt install --no-install-recommends -y libsm6 libgl-dev && rm -rf /var/lib/apt/lists/*;

# pip packages for wsiprocess
ADD ./ $HOME
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e .

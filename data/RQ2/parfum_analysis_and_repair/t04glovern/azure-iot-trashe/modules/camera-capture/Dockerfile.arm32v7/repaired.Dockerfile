FROM balenalib/raspberrypi3:stretch

# Enable cross building of ARM on x64 hardware, Remove this and the cross-build-end if building on ARM hardware.
RUN [ "cross-build-start" ]

# Install dependencies
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
    libatlas3-base libsz2 libharfbuzz0b libtiff5 libjasper1 libilmbase12 \
    libopenexr22 libilmbase12 libgstreamer1.0-0 libavcodec57 libavformat57 \
    libavutil55 libswscale4 libqtgui4 libqt4-test libqtcore4 \
    libboost-python-dev python3-pip git wget \
    python3-numpy build-essential libhdf5-100 python3-pygame \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoremove

RUN export PIP_DEFAULT_TIMEOUT=100
COPY requirements.txt .
RUN pip3 install --no-cache-dir --upgrade setuptools && pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /app
ADD /app/ .

# disable python buffering to console out (https://docs.python.org/2/using/cmdline.html#envvar-PYTHONUNBUFFERED)
ENV PYTHONUNBUFFERED=1

# Expose the port
EXPOSE 5012

RUN [ "cross-build-end" ]

ENTRYPOINT [ "python3", "-u", "./main.py" ]

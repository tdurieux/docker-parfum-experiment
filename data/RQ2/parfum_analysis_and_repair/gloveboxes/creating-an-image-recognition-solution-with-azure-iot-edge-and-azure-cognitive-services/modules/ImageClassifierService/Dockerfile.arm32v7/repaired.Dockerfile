FROM balenalib/raspberrypi3:stretch

# Enable cross building of ARM on x64 hardware, Remove this and the cross-build-end if building on ARM hardware.
RUN [ "cross-build-start" ]

# Install dependencies
RUN apt-get update &&  apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        build-essential \
        python3-dev \
        libopenjp2-7-dev \
        libtiff5-dev \
        zlib1g-dev \
        libjpeg-dev \
        libatlas-base-dev \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get -y autoremove

# Python dependencies

# RUN pip3 install --upgrade setuptools && pip3 install --upgrade pip
# RUN pip3 install pillow numpy flask tensorflow ptvsd

# Python dependencies
RUN export PIP_DEFAULT_TIMEOUT=100
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir pillow
RUN pip3 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir tensorflow

# Add the application
ADD app /app

# Expose the port
EXPOSE 80
EXPOSE 5679

# Set the working directory
WORKDIR /app

# End cross building of ARM on x64 hardware, Remove this and the cross-build-start if building on ARM hardware.
RUN [ "cross-build-end" ]

# Run the flask server for the endpoints
CMD ["python3","iotedge_model.py"]
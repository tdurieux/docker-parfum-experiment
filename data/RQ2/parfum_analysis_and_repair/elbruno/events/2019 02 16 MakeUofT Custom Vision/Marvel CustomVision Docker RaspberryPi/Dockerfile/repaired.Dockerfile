#FROM resin/raspberrypi3-python:3.6

#ADD app /app

#  pip upgrade
#RUN pip3 install --upgrade pip

#  pip install tensorflow
#RUN pip3 install tensorflow>=1.0; exit 0

#  install other requirements
#RUN pip3 install -r /app/requirements.txt

# Bruno changes
FROM resin/rpi-raspbian:stretch

#RUN [ "cross-build-start" ]

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
        python3 \
        python3-pip \
        build-essential \
        python3-dev \
        libopenjp2-7-dev \
        libtiff5-dev \
        zlib1g-dev \
        libjpeg-dev \
        libatlas-base-dev \
        wget && rm -rf /var/lib/apt/lists/*;

COPY /build/arm32v7-requirements.txt arm32v7-requirements.txt

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir -r arm32v7-requirements.txt

ADD app /app

# Expose the port
EXPOSE 80

# Set the working directory
WORKDIR /app

#RUN [ "cross-build-end" ]

# Run the flask server for the endpoints
CMD python app.py
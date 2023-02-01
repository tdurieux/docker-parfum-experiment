FROM ubuntu:xenial

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libcurl4-openssl-dev \
    python3-pip python3-dev python3-numpy python-opencv build-essential \
    libgtk2.0-dev libboost-python-dev git portaudio19-dev  && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade setuptools && pip3 install --no-cache-dir --upgrade pip
# RUN python -m pip install --upgrade pip setuptools wheel
COPY /build/amd64-requirements.txt ./

RUN pip3 install --no-cache-dir -r amd64-requirements.txt

RUN apt-get update && \
    apt-get install --no-install-recommends -y libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev && \
    rm -rf /var/lib/apt/lists/*

ADD /app/ .
# ADD /build/ .

ENV PYTHONUNBUFFERED=1

EXPOSE 5678

CMD [ "python3", "-u", "./iotedge_camera.py" ]
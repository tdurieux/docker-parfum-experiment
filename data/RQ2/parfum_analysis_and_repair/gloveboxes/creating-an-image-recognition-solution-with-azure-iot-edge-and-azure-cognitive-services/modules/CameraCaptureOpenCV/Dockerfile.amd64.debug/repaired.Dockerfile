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

RUN pip3 install --no-cache-dir pyaudio wave

ADD /app/ .
# ADD /build/ .

EXPOSE 5678

ENV PYTHONUNBUFFERED=1

CMD [ "python3", "-u", "./main.py" ]
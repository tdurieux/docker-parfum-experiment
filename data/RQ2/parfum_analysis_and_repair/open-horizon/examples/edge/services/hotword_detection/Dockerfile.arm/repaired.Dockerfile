FROM arm32v7/ubuntu:18.04

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl ca-certificates wget jq bc vim python3 python3-pip python3-dev g++ sox libatlas-base-dev python3-pyaudio swig alsa alsa-tools flac mosquitto mosquitto-clients \
    && pip3 install --no-cache-dir --no-cache --upgrade pyaudio SpeechRecognition \
    && rm -rf /var/lib/apt/lists/*

COPY model/* /model/
COPY resources/* /resources/
COPY *.so /
COPY *.py /

COPY asound.conf /etc/asound.conf

WORKDIR /
CMD [ "python3", "./hwdetect.py" ]

FROM python:3.9-slim

RUN apt-get -y update && apt-get install --no-install-recommends -y ffmpeg \
    git \
    build-essential \
    cmake \
    && apt-get clean && rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*; # Install FFmpeg and Cmake






WORKDIR /FaceRecog

COPY ./ ./

RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["bash"]
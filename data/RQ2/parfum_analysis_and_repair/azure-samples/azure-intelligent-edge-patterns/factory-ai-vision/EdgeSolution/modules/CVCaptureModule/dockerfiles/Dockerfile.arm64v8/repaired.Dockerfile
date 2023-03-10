FROM intelligentedge/python3-opencv:py3.8.6-cv4.4.0.44-arm64v8


RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    cmake \
    libcurl4-openssl-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*
# libgl1-mesa-glx: opencv2 libGL.so error workaround

WORKDIR /app

ARG SYSTEM_CORES="8"
RUN echo "/usr/bin/make --jobs=${SYSTEM_CORES} \$@" > /usr/local/bin/make && \
    chmod 755 /usr/local/bin/make
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt
RUN rm /usr/local/bin/make

COPY main.py .
COPY streams.py .
COPY stream_manager.py .
COPY utility.py .
# COPY /videos/scenario1-counting-objects.mkv ./videos/
# COPY /videos/scenario2-employ-safety.mkv ./videos/
# COPY /videos/scenario3-defect-detection.mkv ./videos/
COPY ./videos/*  ./videos/

EXPOSE 9000
EXPOSE 5559

CMD ["python", "main.py"]

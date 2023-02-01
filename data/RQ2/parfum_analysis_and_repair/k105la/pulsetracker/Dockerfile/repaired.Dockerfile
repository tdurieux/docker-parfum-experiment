FROM python:3.8
COPY . ./pulsetracker
WORKDIR /pulsetracker
ENV PYTHONPATH /pulse/src
RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN make install
RUN make

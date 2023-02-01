FROM kunalg106/cuda102
RUN apt-get update && apt-get install --no-install-recommends -y cmake-curses-gui libopencv-dev && rm -rf /var/lib/apt/lists/*; COPY NVIDIA-OptiX-SDK-5.1.1-linux64-25109142.sh /

RUN pip install --no-cache-dir opencv-python

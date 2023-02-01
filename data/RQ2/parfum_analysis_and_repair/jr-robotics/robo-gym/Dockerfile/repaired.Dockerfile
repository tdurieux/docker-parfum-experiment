ARG PYTHON_VER
FROM python:$PYTHON_VER
RUN apt-get -y update && apt-get install --no-install-recommends -y unzip libglu1-mesa-dev libgl1-mesa-dev libosmesa6-dev xvfb patchelf ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pytest pytest-rerunfailures
ARG CACHEBUST=1
COPY . /usr/local/robo-gym/
WORKDIR /usr/local/robo-gym/
RUN pip install --no-cache-dir .
ENTRYPOINT ["/usr/local/robo-gym/bin/docker_entrypoint"]
CMD ["bash"]

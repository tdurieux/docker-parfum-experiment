FROM workflow_base

RUN apt-get clean
RUN apt-get update && apt-get -y --no-install-recommends --force-yes --fix-missing install yasm ffmpeg && rm -rf /var/lib/apt/lists/*;

COPY main.py /proxy/main.py
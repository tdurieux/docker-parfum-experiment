FROM ubuntu:latest

RUN apt-get update \
 && apt-get install --no-install-recommends git python3 python3-pip -y \
 && git clone https://github.com/s0md3v/Photon.git \
 && cd /Photon \
 && pip3 install --no-cache-dir -r requirements.txt \
 && mkdir /output && rm -rf /var/lib/apt/lists/*;

WORKDIR Photon

VOLUME /output

ENTRYPOINT [ "python3", "photon.py" ]
CMD ["--help"]

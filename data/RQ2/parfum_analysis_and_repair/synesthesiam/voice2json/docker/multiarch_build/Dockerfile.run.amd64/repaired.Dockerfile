FROM ubuntu:eoan

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 \
        libportaudio2 libatlas3-base libgfortran4 \
        ca-certificates \
        perl sox alsa-utils espeak && rm -rf /var/lib/apt/lists/*;
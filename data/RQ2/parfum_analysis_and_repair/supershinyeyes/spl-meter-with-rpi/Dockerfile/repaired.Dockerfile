FROM resin/rpi-raspbian:latest

# Install conda for scientific python and PyAudio Dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    libportaudio0 && rm -rf /var/lib/apt/lists/*;
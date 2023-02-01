# You can change pytorch image to one that's compatible
# with your system https://hub.docker.com/r/pytorch/pytorch/tags
FROM pytorch/pytorch

# install utilities
RUN apt update && \
    apt install --no-install-recommends vim net-tools ffmpeg portaudio19-dev \
    alsa-base alsa-utils \
    -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /VoiceAssistant
COPY . /VoiceAssistant
RUN pip install --no-cache-dir -r requirements.txt
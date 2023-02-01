FROM continuumio/miniconda3
RUN apt-get update && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash voice_smith
WORKDIR /home/voice_smith
COPY ./assets /home/voice_smith/assets
USER voice_smith

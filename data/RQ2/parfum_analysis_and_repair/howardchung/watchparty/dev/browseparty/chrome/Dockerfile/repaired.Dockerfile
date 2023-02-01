FROM siomiz/chrome

RUN apt-get update

RUN apt-get install --no-install-recommends -y libasound2 alsa-utils alsa-oss && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y pulseaudio && rm -rf /var/lib/apt/lists/*;
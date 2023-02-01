FROM   vikings/ffmpeg-ubuntu
RUN apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:longsleep/golang-backports && \
    apt-get update && \
    apt-get install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p ~/go/src
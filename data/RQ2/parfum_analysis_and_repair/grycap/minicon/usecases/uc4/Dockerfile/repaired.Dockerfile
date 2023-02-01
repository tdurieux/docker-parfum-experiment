FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

from ubuntu:18.10

# Install Python
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
      python \
      python-dev \
      python-pip && rm -rf /var/lib/apt/lists/*;

# Install youtube-dl
RUN pip install --no-cache-dir youtube_dl

# Install ffmpeg
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

# Install AWS cli
RUN pip install --no-cache-dir awscli

# Put executable script at root
COPY run /root/
RUN chmod +x /root/run
ENTRYPOINT ["/root/run"]

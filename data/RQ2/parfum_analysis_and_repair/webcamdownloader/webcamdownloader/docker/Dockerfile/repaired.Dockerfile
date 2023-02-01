FROM ubuntu:20.04

ADD WebcamDownloaderLinux_20.04_cli /bin/
RUN apt-get update && \
    apt-get -y --no-install-recommends install openssl && \
    chmod +x /bin/WebcamDownloaderLinux_20.04_cli && \
    mkdir -p /app/config && rm -rf /var/lib/apt/lists/*;
ENV WEBCAM_DOWNLOADER_OPTIONS_DIR=/app/config
ENTRYPOINT ["/bin/WebcamDownloaderLinux_20.04_cli"]

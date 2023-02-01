FROM ubuntu:latest
RUN apt update -y && apt install --no-install-recommends unzip curl -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://rclone.org/install.sh | bash
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD /entrypoint.sh

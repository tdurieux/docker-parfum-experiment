FROM simppru/arm32-build-image:latest
RUN apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

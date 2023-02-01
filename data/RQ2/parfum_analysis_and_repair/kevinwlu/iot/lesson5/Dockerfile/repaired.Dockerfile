FROM balenalib/rpi-raspbian:latest 
ENTRYPOINT []

RUN apt update && \
    apt -qy --no-install-recommends install curl ca-certificates && rm -rf /var/lib/apt/lists/*;

CMD ["curl", "https://docker.com"]

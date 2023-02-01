FROM debian:bullseye
RUN apt update && apt install --no-install-recommends -y systemd python3-pip python3.7 && rm -rf /var/lib/apt/lists/*;
CMD ["/bin/systemd"]
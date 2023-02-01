FROM debian:sid

RUN apt update && apt install --no-install-recommends -y chromium chromium-driver python3-selenium && apt clean && rm -rf /var/lib/apt/lists/*;

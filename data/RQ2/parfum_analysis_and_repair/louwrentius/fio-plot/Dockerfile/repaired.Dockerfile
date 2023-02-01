FROM debian:stable-slim
WORKDIR .
COPY . .
RUN apt update && apt install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -e .

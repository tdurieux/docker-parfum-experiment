FROM debian:sid-slim

RUN apt-get update && apt-get install --no-install-recommends -y libgomp1 && rm -rf /var/lib/apt/lists/*;

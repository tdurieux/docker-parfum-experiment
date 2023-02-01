FROM debian:stable

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes dos2unix exiftool && rm -rf /var/lib/apt/lists/*;

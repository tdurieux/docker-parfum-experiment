FROM ubuntu:20.10
LABEL author="Quinn D Granfor, spootdev@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends quake4-server -y && rm -rf /var/lib/apt/lists/*;
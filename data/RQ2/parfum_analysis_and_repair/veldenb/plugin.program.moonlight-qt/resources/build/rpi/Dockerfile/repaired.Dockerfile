# Use latest compatible Debian version
FROM navikey/raspbian-buster

# See Installing Moonlight Qt on Raspberry Pi 4 (https://github.com/moonlight-stream/moonlight-docs/wiki/Installing-Moonlight-Qt-on-Raspberry-Pi-4)
RUN sudo apt-get update \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl apt-transport-https \
 && curl -1sLf 'https://dl.cloudsmith.io/public/moonlight-game-streaming/moonlight-qt/setup.deb.sh' | sudo -E bash \
 && sudo apt-get update \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y moonlight-qt=4.1.0-1 libgl1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Script to copy the needed libraries
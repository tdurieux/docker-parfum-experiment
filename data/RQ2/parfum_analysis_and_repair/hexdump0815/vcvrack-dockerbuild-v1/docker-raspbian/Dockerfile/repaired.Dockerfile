FROM raspbian-buster

RUN apt-get update && apt-get -y --no-install-recommends install build-essential git gdb curl cmake libx11-dev libglu1-mesa-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev zlib1g-dev libasound2-dev libgtk2.0-dev libjack-jackd2-dev jq zip wget unzip vim libstdc++-7-dev libavcodec-dev premake4 && rm -rf /var/lib/apt/lists/*;

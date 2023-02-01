FROM debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y gcc g++ g++-mingw-w64-x86-64 git make tar zip unzip gdb curl cmake libx11-dev libglu1-mesa-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev zlib1g-dev libasound2-dev libgtk2.0-dev libgtk-3-dev libjack-jackd2-dev jq zstd libpulse-dev && rm -rf /var/lib/apt/lists/*;

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

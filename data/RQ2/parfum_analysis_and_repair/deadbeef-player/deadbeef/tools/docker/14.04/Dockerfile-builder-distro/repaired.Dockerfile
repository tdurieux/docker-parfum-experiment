FROM deadbeef-builder-player-clang-14.04

RUN apt-get -qq update && apt-get install --no-install-recommends -y -qq libjansson-dev libdispatch-dev libblocksruntime-dev && rm -rf /var/lib/apt/lists/*;


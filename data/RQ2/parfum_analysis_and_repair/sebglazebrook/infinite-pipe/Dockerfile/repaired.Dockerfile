FROM sebglazebrook/rust-nightly:latest

RUN apt-get update && apt-get install --no-install-recommends --yes gcc make libncurses5-dev && rm -rf /var/lib/apt/lists/*;

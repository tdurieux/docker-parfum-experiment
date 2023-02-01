FROM jugeeya/cargo-skyline:2.1.0

ENV HOME /root

RUN apt-get update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
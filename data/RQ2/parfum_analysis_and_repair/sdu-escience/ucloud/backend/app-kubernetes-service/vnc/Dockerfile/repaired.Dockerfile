FROM ubuntu:18.10
RUN apt-get update && apt-get install --no-install-recommends -y x11vnc xvfb firefox && rm -rf /var/lib/apt/lists/*;
ENV HOME=/
CMD x11vnc -forever -nopw -create -xkb

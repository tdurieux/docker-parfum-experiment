FROM balenalib/raspberrypi3-64

WORKDIR /openpnp-capture
RUN apt-get update && apt-get install --no-install-recommends -y libgtk-3-dev nasm cmake && rm -rf /var/lib/apt/lists/*;

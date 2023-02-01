FROM gnuk:latest
LABEL Description="Image for building gnuK with debugging"

RUN apt install --no-install-recommends -y gdb-arm-none-eabi && apt clean && rm -rf /var/lib/apt/lists/*;

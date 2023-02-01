FROM rust

RUN apt-get update && apt-get install --no-install-recommends scons libsdl2-dev python3 python3-pip libsdl2-image-dev llvm-dev libclang-dev clang protobuf-compiler libusb-1.0-0-dev -y && rm -rf /var/lib/apt/lists/*;
RUN git clone --recursive https://github.com/trezor/trezor-firmware/ trezor-firmware
WORKDIR /trezor-firmware/core
RUN pip install --no-cache-dir poetry
RUN poetry install
RUN poetry run make build_unix
CMD ["poetry", "run", "./emu.py", "--headless", "--slip0014", "-q"]

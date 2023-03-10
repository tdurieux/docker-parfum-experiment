ARG BASE_IMAGE=rewriting/gtirb/ubuntu20
FROM $BASE_IMAGE

# Install pre-commit
RUN pip3 install --no-cache-dir "virtualenv<20.0.0"
RUN pip3 install --no-cache-dir pre-commit

# Install clang-format
RUN apt-get -y --no-install-recommends install clang-format unzip \
    libboost-filesystem-dev libboost-filesystem1.71.0 \
    libboost-system-dev libboost-system1.71.0 \
    libboost-program-options-dev libboost-program-options1.71.0 \
    gcovr && rm -rf /var/lib/apt/lists/*;

# Run pre-commit once so the hooks are installed
COPY . /gt/gtirb-pprinter
WORKDIR /gt/gtirb-pprinter
RUN pre-commit install-hooks
WORKDIR /
RUN rm -rf /gt/gtirb-pprinter

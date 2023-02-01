FROM prusa3d/gcc-multilib:10
RUN apt-get clean && \
    apt-get update -qq -y && \
    apt-get install --no-install-recommends curl python3 python3-pip libncurses5 g++-multilib -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pre-commit ecdsa
WORKDIR /work
ADD utils/bootstrap.py bootstrap.py
RUN gcc --version
RUN python3 bootstrap.py

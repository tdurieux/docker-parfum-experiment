FROM cossacklabs/ci-py-go-themis


RUN sudo apt-get -qq -y --no-install-recommends install libsodium-dev pkg-config && rm -rf /var/lib/apt/lists/*;

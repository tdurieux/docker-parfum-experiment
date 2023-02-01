RUN apt-get install -y --no-install-recommends libsm6 libxrender1 libfontconfig1 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://sdk.cloud.google.com | bash
ENV PATH="$PATH:/root/google-cloud-sdk/bin"


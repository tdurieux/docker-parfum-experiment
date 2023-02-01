FROM rustembedded/cross:x86_64-unknown-linux-gnu-0.2.1
RUN apt-get update && apt-get install --no-install-recommends libssl-dev postgresql-server-dev-all -y && rm -rf /var/lib/apt/lists/*;
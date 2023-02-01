FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y sudo curl && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > init-rustup.sh && chmod +x ./init-rustup.sh && ./init-rustup.sh -y

ADD ./scripts/ /app/scripts
WORKDIR /app
RUN scripts/install-ubuntu-dependencies.sh

ADD . /app/

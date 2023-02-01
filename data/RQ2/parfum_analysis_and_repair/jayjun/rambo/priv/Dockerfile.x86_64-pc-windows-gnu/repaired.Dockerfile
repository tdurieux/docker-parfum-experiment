FROM rustembedded/cross:x86_64-pc-windows-gnu

WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH=/root/.cargo/bin:$PATH
RUN rustup target add x86_64-pc-windows-gnu

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

COPY . /app
CMD ["cargo", "build", "--release", "--target", "x86_64-pc-windows-gnu"]

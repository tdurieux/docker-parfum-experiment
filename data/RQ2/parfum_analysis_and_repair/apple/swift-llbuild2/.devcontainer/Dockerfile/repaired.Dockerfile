FROM swift:focal

RUN apt-get update && apt-get install --no-install-recommends -y \
    python \
    libsqlite3-dev \
    libncurses5-dev && rm -rf /var/lib/apt/lists/*;

CMD ["zsh"]
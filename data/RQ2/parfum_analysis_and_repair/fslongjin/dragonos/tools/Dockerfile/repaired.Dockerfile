FROM debian:bullseye
RUN apt update \
    && apt install --no-install-recommends -y git xorriso build-essential && rm -rf /var/lib/apt/lists/*;
VOLUME ["/user_data"]

CMD tail -f /dev/null
FROM debian:buster

# emits an info and a warning level violation.
RUN apt-get install -y --no-install-recommends foo && rm -rf /var/lib/apt/lists/*;

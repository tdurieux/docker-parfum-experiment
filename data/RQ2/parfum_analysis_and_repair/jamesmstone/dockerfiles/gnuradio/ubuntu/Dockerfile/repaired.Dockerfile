FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends gnuradio -y && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["gnuradio-companion"]

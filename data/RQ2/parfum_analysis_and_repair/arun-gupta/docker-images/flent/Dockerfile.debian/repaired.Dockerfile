FROM debian:stretch

RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y flent && rm -rf /var/lib/apt/lists/*;

CMD flent

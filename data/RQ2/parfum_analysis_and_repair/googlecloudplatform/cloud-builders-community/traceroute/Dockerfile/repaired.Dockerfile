FROM debian

RUN apt-get update && apt-get install -y --no-install-recommends traceroute && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["traceroute"]

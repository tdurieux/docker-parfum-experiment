FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y stress && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/usr/bin/stress"]
CMD []

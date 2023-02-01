FROM debian:jessie
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY mqtt_blackbox_exporter /bin/mqtt_blackbox_exporter
ENTRYPOINT ["/bin/mqtt_blackbox_exporter"]
CMD ["-config.file /config.yaml"]

FROM docker.elastic.co/beats/metricbeat:6.5.4

HEALTHCHECK CMD [ curl -f https://localhost:6060/debug/vars]

EXPOSE 6060
CMD ["-httpprof", ":6060", "-e"]

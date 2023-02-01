# {{ distro }} pbench-agent-tool-data-sink  image
FROM pbench-agent-tools-{{ distro }}:{{ tag }}

VOLUME /var/lib/pbench-agent

# Port 8080 should be Bottle server, 9090 optional Prometheus server, and 44566
# the optional pmproxy server.
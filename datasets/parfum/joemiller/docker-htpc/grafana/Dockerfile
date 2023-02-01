FROM grafana/grafana:8.3.3

# NOTE: this doesn't work because the /var/lib/grafana/plugins is mounted in from the host.
# to insall plugins, docker-exec into the running container, run the plugin install command, then retart the container
#RUN grafana-cli plugins install grafana-worldmap-panel

USER nobody

# disable x-frame-options: deny, so that we can be used with organizr
ENV GF_SECURITY_ALLOW_EMBEDDING=true

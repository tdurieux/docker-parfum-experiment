# {{ distro }} pbench-agent-tool-meister image
FROM pbench-agent-tools-{{ distro }}:{{ tag }}

# Port 9400 should be the optional dcgm tool, 9100 the optional node_exporter
# tool, and 55677 the pcp (pmcd) tool.
FROM docker.elastic.co/kibana/kibana:6.0.0-rc1
HEALTHCHECK CMD [ curl -f https://localhost:5601/api/status | grep '"disconnects"']

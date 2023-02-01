FROM docker.elastic.co/kibana/kibana:6.2.4
HEALTHCHECK CMD [ curl -f https://localhost:5601/api/status | grep '"disconnects"']

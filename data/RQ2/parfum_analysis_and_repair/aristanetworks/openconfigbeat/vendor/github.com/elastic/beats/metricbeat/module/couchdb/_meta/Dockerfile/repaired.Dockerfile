FROM apache/couchdb:1.7
COPY ./local.ini /etc/couchdb/local.ini
EXPOSE 5984
HEALTHCHECK CMD [ curl -f https://localhost:5984/ | grep Welcome]

FROM envoyproxy/envoy-dev:latest

COPY ./envoy-backend.yaml /etc/envoy.yaml
COPY ./certs/ca.crt /certs/cacert.pem
COPY ./certs/postgres-backend.example.com.crt /certs/servercert.pem
COPY ./certs/example.com.key /certs/serverkey.pem

RUN chmod go+r /etc/envoy.yaml /certs/cacert.pem /certs/serverkey.pem /certs/servercert.pem
CMD ["/usr/local/bin/envoy", "-c /etc/envoy.yaml"]
FROM alpine:latest

COPY ./consul-api-gateway /bin/consul-api-gateway
ENTRYPOINT ["/bin/consul-api-gateway"]
CMD ["version"]
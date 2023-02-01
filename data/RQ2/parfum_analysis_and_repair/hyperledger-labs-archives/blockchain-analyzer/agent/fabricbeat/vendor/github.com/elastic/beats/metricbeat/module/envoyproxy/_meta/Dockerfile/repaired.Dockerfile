FROM envoyproxy/envoy:v1.7.0
RUN apt-get update
COPY ./envoy.json /etc/envoy.json
EXPOSE 10000 9901
HEALTHCHECK CMD [ wget -O - https://localhost:9901/clusters | grep health_flags | grep healthy]
CMD /usr/local/bin/envoy -c /etc/envoy.json


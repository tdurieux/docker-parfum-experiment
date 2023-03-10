ARG ENVOY_VRP_BASE_IMAGE
FROM $ENVOY_VRP_BASE_IMAGE

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y libc++1 supervisor gdb strace tshark \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* \
    && rm -rf /var/lib/apt/lists/*

ADD configs/google-vrp/envoy-edge.yaml /etc/envoy/envoy-edge.yaml
ADD configs/google-vrp/envoy-origin.yaml /etc/envoy/envoy-origin.yaml
ADD configs/google-vrp/launch_envoy.sh /usr/local/bin/launch_envoy.sh
ADD configs/google-vrp/supervisor.conf /etc/supervisor.conf
ADD test/config/integration/certs/serverkey.pem /etc/envoy/certs/serverkey.pem
ADD test/config/integration/certs/servercert.pem /etc/envoy/certs/servercert.pem
# ADD %local envoy bin% /usr/local/bin/envoy

EXPOSE 10000
EXPOSE 10001

CMD ["supervisord", "-c", "/etc/supervisor.conf"]

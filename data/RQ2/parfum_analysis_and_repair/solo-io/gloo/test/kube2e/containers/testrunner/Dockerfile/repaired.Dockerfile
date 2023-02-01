FROM ubuntu:18.04

RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
COPY --from=lachlanevenson/k8s-kubectl:v1.10.3 /usr/local/bin/kubectl /usr/local/bin/kubectl

# Python
RUN apt-get install --no-install-recommends -y python; rm -rf /var/lib/apt/lists/*; apt clean

COPY root.crt /

CMD ["/bin/sh", "-c", "echo 'STARTING SLEEP! Access me.' && /bin/sleep 36000"]
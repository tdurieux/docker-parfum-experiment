# Copy kubeflare into a thin image
FROM debian:buster
WORKDIR /

RUN apt-get update \
 && apt-get -y --no-install-recommends install \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD ./bin/kubeflare /kubeflare

RUN useradd -c 'kubeflare user' -m -d /home/kubeflare -s /bin/bash -u 1001 kubeflare
USER kubeflare
ENV HOME /home/kubeflare

ENTRYPOINT ["/kubeflare", "manager"]

FROM debian:stable

RUN apt-get update && apt-get install --no-install-recommends -y vim less virt-what net-tools procps salt-master && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["salt-master", "-l", "debug"]
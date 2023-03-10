FROM monroe/base

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y python-pyroute2 python-ipaddress && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY files/* /opt/monroe/

ENTRYPOINT ["dumb-init", "--", "/opt/monroe/runme.py"]

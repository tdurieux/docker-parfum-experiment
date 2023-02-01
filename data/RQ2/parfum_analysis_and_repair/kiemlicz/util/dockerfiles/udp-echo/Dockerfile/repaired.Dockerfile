FROM debian:buster-slim

ENV UDP_PORT="9999"

RUN apt-get update && apt-get install --no-install-recommends -y python3-minimal && rm -rf /var/lib/apt/lists/*;

COPY server.py /opt/

ENTRYPOINT [ "python3" ]
CMD [ "/opt/server.py" ]

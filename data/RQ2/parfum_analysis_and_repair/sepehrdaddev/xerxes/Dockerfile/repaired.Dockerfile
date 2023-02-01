FROM ubuntu:latest
COPY ./Xerxes /opt/Xerxes/
COPY ./useragents /opt/Xerxes/
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/Xerxes
ENTRYPOINT ["/bin/sh"]
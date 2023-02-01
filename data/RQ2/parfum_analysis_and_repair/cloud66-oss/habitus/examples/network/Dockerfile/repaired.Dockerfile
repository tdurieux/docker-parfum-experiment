FROM ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

ARG host
ARG port
ENV ASSET /asset
RUN wget -q -O $ASSET https://$host:$port/
RUN cat $ASSET

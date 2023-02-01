FROM          ubuntu:16.04

ENV           DEBIAN_FRONTEND noninteractive

RUN			apt-get update
RUN			apt-get update
RUN apt-get install --no-install-recommends -y curl vim apt-transport-https && rm -rf /var/lib/apt/lists/*;


RUN			echo "deb https://packagecloud.io/grafana/stable/debian/ wheezy main" | tee /etc/apt/sources.list.d/grafana.list
RUN curl -f https://packagecloud.io/gpg.key | apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y grafana jq && rm -rf /var/lib/apt/lists/*;


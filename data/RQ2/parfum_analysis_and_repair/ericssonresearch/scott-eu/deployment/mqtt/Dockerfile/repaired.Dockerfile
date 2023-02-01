FROM ubuntu:16.10
LABEL maintainer "konstantinos.vandikas@ericsson.com"

# update/upgrade base system
RUN apt-get update && apt-get -yq --no-install-recommends install wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq upgrade

# misc apps


# download emqtt
WORKDIR /opt
RUN wget --quiet https://emqtt.com/static/brokers/emqttd-ubuntu16.04-v2.3-beta.4.zip
RUN unzip emqttd-ubuntu16.04-v2.3-beta.4.zip

# start emqtt daemon
CMD /opt/emqttd/bin/emqttd start && tail -f /dev/null

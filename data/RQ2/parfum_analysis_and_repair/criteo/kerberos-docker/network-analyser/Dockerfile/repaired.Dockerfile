# Dockerfile - network-analyser
#
# see docker-compose.yml

FROM minimal-ubuntu

# network analyser wireshark/tshark
RUN apt-get -y --no-install-recommends install wireshark tshark && rm -rf /var/lib/apt/lists/*;

# run command
CMD ["wireshark"]

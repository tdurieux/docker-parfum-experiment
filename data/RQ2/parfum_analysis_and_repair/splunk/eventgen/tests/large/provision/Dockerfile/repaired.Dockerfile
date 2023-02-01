FROM splunk/splunk:7.3-debian

RUN sudo apt-get update

RUN echo "installing docker dependencies and development tools" && \
    sudo apt-get --assume-yes -y --no-install-recommends install curl vim && rm -rf /var/lib/apt/lists/*;

COPY ["provision.sh", "add_httpevent_collector.sh", "/opt/splunk/"]

FROM bitnami/minideb
LABEL maintainer="Alvaro Lopez Garcia <aloga@ifca.unican.es>"
LABEL version="0.10.0"
LABEL description="DEEP as a Service Generic Container"

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
        git \
        curl \
        python-netifaces \
        python-setuptools \
        python-pip \
        python-wheel \
        python3-netifaces \
        python3-setuptools \
        python3-pip \
        python3-wheel && rm -rf /var/lib/apt/lists/*;

WORKDIR /srv

# Install rclone
RUN curl -f https://downloads.rclone.org/rclone-current-linux-amd64.deb --output rclone-current-linux-amd64.deb && \
    dpkg -i rclone-current-linux-amd64.deb && \
    apt-get install -y -f && \
    rm rclone-current-linux-amd64.deb

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /tmp/*

## We can use pip or pip3, depending on the python version that we want to use
RUN pip3 install --no-cache-dir 'deepaas>=0.4.0' && \
    pip install --no-cache-dir 'deepaas>=0.4.0'

EXPOSE 5000

# Do not run DEEPaaS within a shell (i.e. using "sh -c") here below,
# as the shell will become PID 1, and this will cause that the Docker
# container will not stop on a "docker stop" command, as Docker sends
# SIGTERM to the PID 1 (the shell will not propagate the signal to
# the child process.
CMD ["deepaas-run", "--openwhisk-detect", "--listen-ip", "0.0.0.0", "--listen-port", "5000"]

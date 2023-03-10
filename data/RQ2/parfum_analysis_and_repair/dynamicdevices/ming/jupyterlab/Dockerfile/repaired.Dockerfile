FROM debian:stable-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-dev \
    python3-zmq \
    python3-pandas \
    python3-setuptools \
    python3-markupsafe \
    python3-prometheus-client \
    python3-tornado python3-wheel \
    build-essential \
    tini \
    sudo \
&& rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/src/app/jupyter/start.sh

COPY requirements.txt /root/
RUN pip3 install --no-cache-dir -r /root/requirements.txt && \
    jupyter lab --generate-config

# This usage of Tini is in order to prevent potential issues with PID reaping as mentioned here:
# https://jupyter-notebook.readthedocs.io/en/stable/public_server.html

ENTRYPOINT ["/usr/bin/tini", "--"]
RUN mkdir /data

RUN useradd -Ms /bin/bash -d /usr/src/app/jupyter jupyter \
    && chown -R jupyter:jupyter /data \
    && chown -R jupyter:jupyter /usr/src/app/jupyter

RUN echo "jupyter     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jupyter

WORKDIR /data
VOLUME ["/data"]
EXPOSE 8888

CMD ["/bin/bash", "/usr/src/app/jupyter/start.sh"]

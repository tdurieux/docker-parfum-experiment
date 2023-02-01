FROM ubuntu:20.04
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common gcc && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.8-distutils \
    python3.8-dev \
    python3-pip \
    python3.8-venv \
    curl \

    default-jdk-headless && rm -rf /var/lib/apt/lists/*;
RUN python3.8 -m venv /opt/venv
RUN /opt/venv/bin/pip install wheel requests gunicorn
COPY . /opt/whyis
RUN /opt/venv/bin/pip install -e /opt/whyis
WORKDIR '/app'
CMD [ "/opt/venv/bin/whyis", "run", "-h", "0.0.0.0" ]

FROM docker.internal.kevinlin.info/infra/ci-base:0.1.1

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y python-dev libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

COPY sample-config.json /etc/orion/config.json

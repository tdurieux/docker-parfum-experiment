FROM docker.internal.kevinlin.info/infra/ci-base:0.2.2

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y python-dev libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

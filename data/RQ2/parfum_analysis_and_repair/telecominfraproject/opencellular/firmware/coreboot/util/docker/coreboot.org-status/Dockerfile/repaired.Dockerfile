FROM debian:sid

RUN apt-get update && apt-get install --no-install-recommends -y python git bc && apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD board-status.html kconfig2html run.sh /opt/tools/

ENTRYPOINT /opt/tools/run.sh

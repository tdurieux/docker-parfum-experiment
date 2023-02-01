FROM debian:latest

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install \
  python3 \
  python-pip && rm -rf /var/lib/apt/lists/*;

CMD python3 -V;bash '/etc/shared/scripts/drive'

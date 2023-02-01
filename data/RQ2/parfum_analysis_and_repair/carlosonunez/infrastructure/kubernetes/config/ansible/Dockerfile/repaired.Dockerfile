FROM williamyeh/ansible:ubuntu16.04
MAINTAINER Carlos Nunez <dev@carlosnunez.me>

RUN apt update && \
  apt -y --no-install-recommends install dbus && \
  mkdir -p /run/dbus && \
  pip install --no-cache-dir docker-py boto3 botocore && rm -rf /var/lib/apt/lists/*;

CMD ["/usr/sbin/init"]

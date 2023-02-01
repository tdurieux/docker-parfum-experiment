FROM ubuntu:14.04

RUN export DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

ADD ./test.sh /usr/local/bin/test.sh

CMD ["test.sh"]

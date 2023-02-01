FROM ubuntu:20.04

RUN apt-get update -qq && apt-get install --no-install-recommends python2.7 -y && rm -rf /var/lib/apt/lists/*;

COPY apkg-tools.py /apkg-tools.py

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

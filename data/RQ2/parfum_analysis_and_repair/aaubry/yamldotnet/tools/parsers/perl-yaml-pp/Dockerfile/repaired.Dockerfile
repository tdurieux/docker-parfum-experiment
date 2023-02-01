FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y libyaml-pp-perl && rm -rf /var/lib/apt/lists/*;
COPY parse.pl /app/
WORKDIR /app

ENTRYPOINT [ "/usr/bin/perl", "-w", "/app/parse.pl" ]

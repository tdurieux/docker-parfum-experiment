FROM gcc:8.1.0
LABEL maintainer="gedorinku <gedorinku@yahoo.co.jp>"

RUN apt-get update && apt-get install -y --no-install-recommends time && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;

RUN sh -c 'echo 127.0.1.1 $(hostname) >> /etc/hosts'

RUN mkdir /tmp/koj-workspace && chmod 777 /tmp/koj-workspace

FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y mono-complete && rm -rf /var/lib/apt/lists/*;



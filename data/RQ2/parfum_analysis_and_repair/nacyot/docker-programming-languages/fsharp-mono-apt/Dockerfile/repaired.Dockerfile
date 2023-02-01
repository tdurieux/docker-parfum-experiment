FROM nacyot/csharp-mono:apt
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get install --no-install-recommends -y fsharp && rm -rf /var/lib/apt/lists/*;

# Set default WORKDIR
WORKDIR /source

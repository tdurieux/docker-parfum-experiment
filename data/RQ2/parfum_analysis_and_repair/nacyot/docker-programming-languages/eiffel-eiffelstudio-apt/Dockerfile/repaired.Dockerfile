FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get update
RUN add-apt-repository -y ppa:eiffelstudio-team/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y eiffelstudio && rm -rf /var/lib/apt/lists/*;

# Set default WORKDIR
WORKDIR /source

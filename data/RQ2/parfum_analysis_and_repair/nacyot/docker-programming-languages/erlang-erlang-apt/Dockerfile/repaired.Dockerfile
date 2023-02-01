FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

# Install base package
RUN apt-get update
RUN apt-get install --no-install-recommends -y unzip wget git && rm -rf /var/lib/apt/lists/*;

# Install Erlang
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install --no-install-recommends -y erlang && rm -rf /var/lib/apt/lists/*;

# Set default WORKDIR
WORKDIR /source

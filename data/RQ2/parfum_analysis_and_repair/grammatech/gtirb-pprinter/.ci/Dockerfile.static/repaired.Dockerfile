FROM docker.grammatech.com/rewriting/gtirb/static

# (re-)install Boost
RUN apt-get -y update && apt-get -y --no-install-recommends install libboost-system-dev libboost-filesystem-dev libboost-program-options-dev && rm -rf /var/lib/apt/lists/*;

# Install pip
RUN apt-get -y update && apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

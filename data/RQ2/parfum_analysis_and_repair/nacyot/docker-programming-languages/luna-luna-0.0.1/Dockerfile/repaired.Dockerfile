FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

# Install base packages
RUN apt-get update && apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;

# Install luna
RUN git clone https://github.com/luna/luna.git /opt/luna
WORKDIR /opt/luna
RUN git checkout 7ae49600ee486bd68
RUN make

# Create symbolic link
RUN bash -c "ln -s /opt/luna/luna /usr/local/bin/"

# Set default WORKDIR
WORKDIR /source

FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

# Install base package
RUN apt-get update && apt-get install -y --no-install-recommends libnspr4 && rm -rf /var/lib/apt/lists/*; # Install js

RUN mkdir -p /opt/js
WORKDIR /opt/js
RUN wget -O /opt/js/js.zip https://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/jsshell-linux-x86_64.zip
RUN unzip js.zip

# Create symbolic link
RUN bash -c "ln -s /opt/js/js /usr/local/bin/"

# Set default WORKDIR
WORKDIR /source

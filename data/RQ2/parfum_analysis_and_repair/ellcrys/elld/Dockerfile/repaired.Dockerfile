FROM golang:1.10.5-stretch

ARG version=latest

# Download the latest release
RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
RUN export elldVersion=$( curl -f -sL https://api.github.com/repos/ellcrys/elld/releases/${version} | jq -r '.assets[].browser_download_url | match("(.*(elld_0.1.0-alpha)_linux.*)") | .captures[1].string')
RUN curl -f -L $( curl -f -sL https://api.github.com/repos/ellcrys/elld/releases/${version} | jq -r '.assets[].browser_download_url | match("(.*linux.*)") | '.string'') > elld_${elldVersion}_linux_x86_64.tar.gz
RUN mkdir elld_${elldVersion}
RUN tar -xf elld_${elldVersion}_linux_x86_64.tar.gz -C elld_${elldVersion} && rm elld_${elldVersion}_linux_x86_64.tar.gz
RUN mv elld_${elldVersion}/elld /usr/local/bin/elld
RUN rm -rf elld_${elldVersion}_linux_x86_64.tar.gz
RUN rm -rf elld_${elldVersion}

# Start client
EXPOSE 9000
EXPOSE 8999
ENTRYPOINT ["elld", "start", "-a", "0.0.0.0:9000"]
FROM debian:buster-slim
LABEL Description="Image for checking out updater-repo"

RUN sed -i 's#deb http://deb.debian.org/debian buster main#deb http://deb.debian.org/debian buster main contrib#g' /etc/apt/sources.list
RUN sed -i 's#deb http://deb.debian.org/debian buster-updates main#deb http://deb.debian.org/debian buster-updates main contrib#g' /etc/apt/sources.list
RUN apt-get update -q && apt-get install --no-install-recommends -qy \
    git \
    python3 \
    curl \
    xmlstarlet && rm -rf /var/lib/apt/lists/*;

# Install repo
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
    curl -f https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && \
    chmod a+x /usr/bin/repo

# checkout script
RUN mkdir /scripts
COPY checkout-oe.sh /scripts/

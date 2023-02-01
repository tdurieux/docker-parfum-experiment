FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends openjdk-8-jre-headless -y && \
    apt-get install --no-install-recommends locales -y && \
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y curl python-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;


# download and install Leiningen
ENV LEIN_ROOT=1
RUN curl -f https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > ./lein
RUN chmod a+x ./lein
RUN mv ./lein /usr/bin/lein
RUN lein version

RUN pip3 install --no-cache-dir streamparse requests elasticsearch confluent_kafka unidecode tensorflow

ENV STORM_USER=storm \
    STORM_CONF_DIR=/conf \
    STORM_DATA_DIR=/data \
    STORM_LOG_DIR=/logs

WORKDIR /opt

# Add a user and make dirs
RUN set -x \
    && useradd  "$STORM_USER" \
    && mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR" \
    && chown -R "$STORM_USER:$STORM_USER" "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"

ARG DISTRO_NAME=apache-storm-1.2.3

# Download Apache Storm, verify its PGP signature, untar and clean up
RUN set -x \
    && wget -q "https://www.apache.org/dist/storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz" \
    && tar -xzf "$DISTRO_NAME.tar.gz" \
    && chown -R "$STORM_USER:$STORM_USER" "$DISTRO_NAME" && rm "$DISTRO_NAME.tar.gz"


ENV PATH /opt/"$DISTRO_NAME"/bin/:$PATH

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apt-get install --no-install-recommends -y inetutils-ping && rm -rf /var/lib/apt/lists/*;
RUN update-ca-certificates -f
WORKDIR /tasks

RUN pip3 install --no-cache-dir psutil

#ENTRYPOINT ["/bin/bash"]

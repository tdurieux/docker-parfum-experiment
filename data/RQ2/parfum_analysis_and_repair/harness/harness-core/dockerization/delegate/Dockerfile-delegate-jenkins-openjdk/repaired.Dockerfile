FROM ubuntu:20.04

RUN apt-get update && \
    apt-get -y --no-install-recommends install curl unzip gnupg2 libgcrypt20 locales && \
    locale-gen en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

COPY apt-source-list /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update && apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

COPY scripts /opt/harness-delegate/

RUN chmod +x /opt/harness-delegate/*.sh

WORKDIR /opt/harness-delegate

RUN ./client_tools.sh && chmod -R 755 /opt/harness-delegate

RUN curl -f -s https://app.harness.io/public/shared/jre/openjdk-11.0.14_9/OpenJDK11U-jre_x64_linux_hotspot_11.0.14_9.tar.gz | tar -xz

ARG watcher_version
RUN curl -f -#k https://app.harness.io/public/shared/watchers/builds/openjdk-8u242/$watcher_version/watcher.jar -o watcher.jar

CMD ./entrypoint.sh && bash -c ' \
    while [[ ! -e watcher.log ]]; do sleep 1s; done; tail -F watcher.log & \
    while [[ ! -e delegate.log ]]; do sleep 1s; done; tail -F delegate.log'

FROM ubuntu:16.04
EXPOSE 4321 4322 4323 443

COPY conf/xtremweb.server.conf /iexec/conf/
COPY conf/xwconfigure.values /iexec/conf/
COPY lib /iexec/lib
COPY bin /iexec/bin/

# Add the script that will set up the configuration in the container
ADD docker/server/start_server.sh /iexec/start_server.sh

WORKDIR /iexec

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && \
       apt-get install --no-install-recommends -y openjdk-8-jdk zip unzip wget make iputils-ping && rm -rf /var/lib/apt/lists/*;

RUN chmod +x /iexec/start_server.sh

ENTRYPOINT [ "/iexec/start_server.sh" ]



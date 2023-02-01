FROM ubuntu:17.04

# building a docker images meant to run with igor
# the image provieds all tools required for the code lab: aws cli, autostacker24, cli53
# run the following command to build the image locally:
#    docker build -t felixb/aws-codelab .

CMD ["/bin/bash"]

ENV \
    CLI53_VERSION=0.8.7 \
    AUTOSTACKER_VERSION=2.7.0 \
    NODE_VERSION=6.x

RUN apt-get update \
 && apt-get install --no-install-recommends -y awscli ruby ruby-dev gcc make curl tree vim \
 && rm -rf /var/lib/apt/* /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;

RUN gem install -v ${AUTOSTACKER_VERSION} autostacker24

RUN curl -f -L -o /usr/local/bin/cli53 https://github.com/barnybug/cli53/releases/download/${CLI53_VERSION}/cli53-linux-amd64 \
 && chmod +x /usr/local/bin/cli53

RUN curl -f -L -o /usr/local/bin/sniper https://lubia-me.qiniudn.com/sniper_linux_amd64 \
 && chmod +x /usr/local/bin/sniper

RUN curl -f -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
 && apt-get install -y --no-install-recommends nodejs \
 && rm -rf /var/lib/apt/* /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;

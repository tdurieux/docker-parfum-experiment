FROM fkrull/multi-python:bionic

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD action.sh /tmp

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y lsb-release iproute2 sudo vim curl build-essential && \
    apt-get install --no-install-recommends -y awscli git zip && \
    chmod 755 /tmp/action.sh && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "/tmp/action.sh" ]

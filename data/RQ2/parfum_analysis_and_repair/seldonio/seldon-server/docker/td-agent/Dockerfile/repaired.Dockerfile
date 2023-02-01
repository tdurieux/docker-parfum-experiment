FROM ubuntu:trusty

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN ( apt-get update && \
        apt-get install --no-install-recommends curl -y && \
        curl -f https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add - && \
        echo "deb http://packages.treasuredata.com/2/ubuntu/trusty/ trusty contrib" | tee /etc/apt/sources.list.d/treasure-data.list && \
        apt-get update && \
        apt-get install --no-install-recommends -y --force-yes td-agent && \
        apt-get install --no-install-recommends -y make gcc patch && \
        td-agent-gem install fluent-plugin-kafka --no-document && \
        apt-get remove -y --auto-remove curl make gcc patch ruby-dev && \
        apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

# Expose the default port
EXPOSE 8888

CMD ["td-agent"]


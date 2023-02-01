FROM node:16.14-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -yq python-pip jq git unzip && \
    pip install --no-cache-dir awscli && rm -rf /var/lib/apt/lists/*;

COPY config.json /config.json
COPY bin/sanity-runner-client-linux /usr/local/bin/sanity-runner
RUN chmod 777 /usr/local/bin/sanity-runner

CMD sanity-runner --config config.json

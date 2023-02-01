FROM alpine:3.4

RUN apk update \
    && apk add --no-cache nodejs docker python3
RUN npm install -g triton json && npm cache clean --force;

# install dependencies
RUN pip3 install --no-cache-dir \
    docker-compose==1.10.0 \
    python-Consul==0.4.7 \
    IPy==0.83

# install test targets
COPY examples/compose/docker-compose.yml /src/compose/docker-compose.yml
COPY examples/triton/docker-compose.yml /src/triton/docker-compose.yml

# install tests
COPY test/testing/testcases.py /src/testcases.py
COPY test/tests.py /src/tests.py
COPY test/tests.sh /src/tests.sh

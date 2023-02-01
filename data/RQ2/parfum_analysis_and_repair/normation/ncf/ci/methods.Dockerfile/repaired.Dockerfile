ARG OS=ubuntu:20.04
FROM ${OS}

RUN if type apt-get; then \
 apt-get update && apt-get install --no-install-recommends -y wget gnupg2 make python3-jinja2 fakeroot acl git; rm -rf /var/lib/apt/lists/*; fi
RUN if type yum; then \
 yum install -y wget gnupg2 make python3-jinja2 acl git; rm -rf /var/cache/yumfi

# Accept all OSes
ENV UNSUPPORTED=y
RUN wget https://repository.rudder.io/tools/rudder-setup && sh ./rudder-setup setup-agent latest || true

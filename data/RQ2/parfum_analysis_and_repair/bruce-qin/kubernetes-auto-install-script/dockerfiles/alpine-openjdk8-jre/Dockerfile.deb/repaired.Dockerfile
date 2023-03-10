FROM debian:buster-slim

RUN apt update && apt install --no-install-recommends -y curl gnupg software-properties-common; \
    curl -f https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -; \
    add-apt-repository -y -u https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ ; \
    mkdir -p mkdir -p /usr/share/man/man1 ; \
    apt install --no-install-recommends -y adoptopenjdk-8-hotspot-jre procps; rm -rf /var/lib/apt/lists/*; \
    rm -rf /var/lib/apt/lists/ ; \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ; \
    echo "Asia/Shanghai" > /etc/timezone

ENTRYPOINT  ["sh"]